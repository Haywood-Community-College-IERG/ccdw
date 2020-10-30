/*
 * 2019-05-29 
 *    * Revised query to better calculate first terms, especiall for CCP students
 *    * Added additional fields for (absolute) first term by student and by program
 *    * Added additional fields for CCP and high school flags
 *    * Added STUDENT_ACAD_CRED to get programs for enrolled students only
 *
 */
IF OBJECT_ID('local.Student_Programs', 'V') IS NOT NULL
    DROP VIEW local.Student_Programs
GO

CREATE VIEW local.Student_Programs AS
WITH 
CCP_Students AS (
    SELECT ccp.Student_ID
         , ccp.Term_ID
         , ccp.Student_Type
      FROM local.CCP_Students_Data ccp
)
, STUDENT_ACAD_CRED AS (
    SELECT DISTINCT
           sac.[STC.PERSON.ID] AS Student_ID
         , sac.[STC.TERM] AS Term_ID
      FROM history.STUDENT_ACAD_CRED_Current sac
     WHERE sac.[STC.STATUS] IN ('A','N','W')
       AND sac.[STC.ACAD.LEVEL] = 'CU'
       AND COALESCE(sac.[STC.TERM],'') <> ''
)
, sp_tn AS (
    SELECT sp.[STPR.STUDENT]
         , sp.[STPR.ACAD.PROGRAM]
         , t.Term_ID
         , t.Term_ID_Numeric
         , sp.[STPR.ADMIT.STATUS]
         , sp.[STPR.CATALOG]
         , sp.[STPR.DEPT]
         , sp_d.[STPR.START.DATE]
         , sp_d.[STPR.END.DATE]
         , sp_sme.[STPR.EVAL.MAJORS]
         , sp_sme.[STPR.EVAL.MAJOR.GPA]
         , sp_sme.[STPR.EVAL.MAJOR.CRED.TOT]
         , sp_sme.[STPR.EVAL.MAJOR.STATUS]
         , sp.[STPR.STUDENT.ED.PLAN]
         , CASE WHEN sp.[STPR.USER1] = '' THEN NULL ELSE sp.[STPR.USER1] END AS [STPR.USER1]
         , CASE WHEN ccp.Student_Type = 'CCP' THEN 'Y' ELSE 'N' END AS "Is CCP Student"
         , CASE WHEN ccp.Student_Type IN ('EC','CCP') THEN 'Y' ELSE 'N' END AS "Is High School"

         -- First_Term_ID_Numeric is the first term for this student in a college-level program 
         --    (i.e., non-CCP, non-Special Credit, etc.)
         , MIN(CASE -- For all the special credit and not program related students, they have not had a first term yet
                WHEN sp.[STPR.ACAD.PROGRAM] LIKE 'T%' THEN NULL
                -- FOR CCP students, they have not had their first term as a college student yet
                WHEN ccp.Student_Type = 'CCP' THEN NULL
                ELSE t.Term_ID_Numeric END) 
                   OVER (PARTITION BY sp.[STPR.STUDENT]
                                    , sp_d.[STPR.START.DATE]) AS First_Term_ID_Numeric

         -- First_Term_ID_Program_Numeric is the first term for this student in a college-level program for this program 
         --    (i.e., non-CCP, non-Special Credit, etc.)
         , MIN(CASE -- For all the special credit and not program related students, they have not had a first term yet
                WHEN sp.[STPR.ACAD.PROGRAM] LIKE 'T%' THEN NULL
                -- FOR CCP students, they have not had their first term as a college student yet
                WHEN ccp.Student_Type = 'CCP' THEN NULL
                ELSE t.Term_ID_Numeric END) 
                   OVER (PARTITION BY sp.[STPR.STUDENT]
                                    , sp.[STPR.ACAD.PROGRAM]
                                    , sp_d.[STPR.START.DATE]) AS First_Term_ID_Program_Numeric

         -- First_Term_ID_Program_Catalog_Numeric is the first term for this student in a college-level program for this program for this catalog
         --    (i.e., non-CCP, non-Special Credit, etc.)
         , MIN(CASE -- For all the special credit and not program related students, they have not had a first term yet
                WHEN sp.[STPR.ACAD.PROGRAM] LIKE 'T%' THEN NULL
                -- FOR CCP students, they have not had their first term as a college student yet
                WHEN ccp.Student_Type = 'CCP' THEN NULL
                ELSE t.Term_ID_Numeric END) 
                   OVER (PARTITION BY sp.[STPR.STUDENT]
                                    , sp.[STPR.ACAD.PROGRAM]
                                    , sp.[STPR.CATALOG]
                                    , sp_d.[STPR.START.DATE]) AS First_Term_ID_Program_Catalog_Numeric

         -- Actual_First_Term_ID_Numeric is the first term where a student is enrolled in any program at the college
         --    (this includes CCP and Special Credit terms)
         , MIN(t.Term_ID_Numeric) 
               OVER (PARTITION BY sp.[STPR.STUDENT]
                                , sp_d.[STPR.START.DATE]) AS Actual_First_Term_ID_Numeric

         -- Actual_First_Term_ID_Program_Numeric is the first term where a student is enrolled in any program at the college for this program 
         --    (this includes CCP and Special Credit terms)
         , MIN(t.Term_ID_Numeric) 
               OVER (PARTITION BY sp.[STPR.STUDENT]
                                , sp.[STPR.ACAD.PROGRAM]
                                , sp_d.[STPR.START.DATE]) AS Actual_First_Term_ID_Program_Numeric

         -- Actual_First_Term_ID_Program_Catalog_Numeric is the first term where a student is enrolled in any program at the college for this program for this catalog
         --    (this includes CCP and Special Credit terms)
         , MIN(t.Term_ID_Numeric) 
               OVER (PARTITION BY sp.[STPR.STUDENT]
                                , sp.[STPR.ACAD.PROGRAM]
                                , sp.[STPR.CATALOG]
                                , sp_d.[STPR.START.DATE]) AS Actual_First_Term_ID_Program_Catalog_Numeric
      FROM history.STUDENT_PROGRAMS_Current sp
      LEFT JOIN history.STUDENT_PROGRAMS__STPR_DATES sp_d
           ON (sp_d.[STPR.STUDENT] = sp.[STPR.STUDENT]
           AND sp_d.[STPR.ACAD.PROGRAM] = sp.[STPR.ACAD.PROGRAM]
           AND sp_d.EffectiveDatetime = sp.EffectiveDatetime)
      LEFT JOIN history.STUDENT_PROGRAMS__STPR_MAJOR_EVAL sp_sme
           ON (sp_sme.[STPR.STUDENT] = sp.[STPR.STUDENT]
           AND sp_sme.[STPR.ACAD.PROGRAM] = sp.[STPR.ACAD.PROGRAM]
           AND sp_sme.EffectiveDatetime = sp.EffectiveDatetime)
    -- Some people do not have a program start date, but do have a catalog year.
      LEFT JOIN dw_dim.Term_CU t
           ON (t.Term_Census_Date >= sp_d.[STPR.START.DATE]
           AND t.Term_Census_Date <= COALESCE(sp_d.[STPR.END.DATE],CAST('9999-12-31' AS DATE)))
      LEFT JOIN CCP_Students ccp
           ON (ccp.Student_ID = sp.[STPR.STUDENT]
           AND ccp.Term_ID = t.Term_ID)
     WHERE sp.[STPR.STUDENT] <> '0'
       AND sp.[STPR.START.DATE] <> ''
       AND sp.[STPR.ACAD.PROGRAM] IS NOT NULL
       AND sp.[STPR.ACAD.PROGRAM] NOT IN ('BSP', 'BSKP', 'AHS', 'CONED','=GED','=HISET', 'HSEGED', 'HSEHISET', 'SPEEDE')
)
SELECT DISTINCT 
       sac.Student_ID AS [Student ID]
     , sac.Term_ID
     , COALESCE(sp_tn.[STPR.ACAD.PROGRAM],'Unknown') AS [Program Code]
     , COALESCE(sp_tn.[STPR.ADMIT.STATUS],'U') AS [Admit Status]
     , COALESCE(sp_tn.[STPR.CATALOG],'UKNW') AS Catalog
     , COALESCE(sp_tn.[STPR.DEPT],'UKNW') AS [Department Code]
     , COALESCE(sp_tn.[STPR.START.DATE],t_ft.Term_Start_Date,t_aft.Term_Start_Date) AS [Program Start Date]
     , sp_tn.[STPR.END.DATE] AS [Program End Date]
     , sp_tn.[STPR.EVAL.MAJORS] AS Major
     , sp_tn.[STPR.EVAL.MAJOR.GPA] AS GPA
     , sp_tn.[STPR.EVAL.MAJOR.CRED.TOT] AS Major_Credits
     , sp_tn.[STPR.EVAL.MAJOR.STATUS] AS Major_Status
     , sp_tn.[STPR.STUDENT.ED.PLAN] AS [Student Ed Plan]
     , COALESCE(sp_tn.[STPR.USER1],'U') AS [Is Primary Program]
     , COALESCE(sp_tn.[Is CCP Student],'U') AS [Is CCP Student]
     , COALESCE(sp_tn.[Is High School],'U') AS [Is High School]
     , t_ft.Term_ID AS [First Term ID]
     , t_ft.Term_Start_Date AS [First Term Start Date]
     , t_ftp.Term_ID AS [First Term ID for Progam]
     , t_ftp.Term_Start_Date AS [First Term Start Date for Program]
     , t_ftpc.Term_ID AS [First Term ID for Progam and Catalog]
     , t_ftpc.Term_Start_Date AS [First Term Start Date for Program and Catalog]
     , t_aft.Term_ID AS [Actual First Term ID]
     , t_aft.Term_Start_Date AS [Actual First Term Start Date]
     , t_aftp.Term_ID AS [Actual First Term ID for Program]
     , t_aftp.Term_Start_Date AS [Actual First Term Start Date for Program]
     , t_aftpc.Term_ID AS [Actual First Term ID for Program and Catalog]
     , t_aftpc.Term_Start_Date AS [Actual First Term Start Date for Program and Catalog]
  FROM STUDENT_ACAD_CRED sac
  LEFT JOIN sp_tn
       ON sp_tn.[STPR.STUDENT] = sac.Student_ID
       AND sp_tn.Term_ID = sac.Term_ID
  LEFT JOIN dw_dim.Term_CU t_ft
    ON t_ft.Term_ID_Numeric = sp_tn.First_Term_ID_Numeric
  LEFT JOIN dw_dim.Term_CU t_ftp
    ON t_ftp.Term_ID_Numeric = sp_tn.First_Term_ID_Program_Numeric
  LEFT JOIN dw_dim.Term_CU t_ftpc
    ON t_ftpc.Term_ID_Numeric = sp_tn.First_Term_ID_Program_Catalog_Numeric
  LEFT JOIN dw_dim.Term_CU t_aft
    ON t_aft.Term_ID_Numeric = sp_tn.Actual_First_Term_ID_Numeric
  LEFT JOIN dw_dim.Term_CU t_aftp
    ON t_aftp.Term_ID_Numeric = sp_tn.Actual_First_Term_ID_Program_Numeric
  LEFT JOIN dw_dim.Term_CU t_aftpc
    ON t_aftpc.Term_ID_Numeric = sp_tn.Actual_First_Term_ID_Program_Catalog_Numeric
 WHERE sp_tn.Term_ID IS NOT NULL
 ;
 GO

 /* THEN SUBMIT THESE STATEMENTS */
IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) + '.' + name = 'local.Student_Programs_Data') 
  DROP TABLE local.Student_Programs_Data
;
SELECT * INTO local.Student_Programs_Data FROM local.Student_Programs
GO

/* This should be scheduled to run AFTER the data has been updated nightly *

DELETE FROM local.Student_Programs_Data
INSERT INTO local.Student_Programs_Data SELECT * FROM local.Student_Programs

*/


/* *

SELECT * --distinct([Student ID])
  FROM local.Student_Programs_Data
  WHERE Term_ID = '2019SP'
    AND [Is CCP Student] = 'Y'
-- */