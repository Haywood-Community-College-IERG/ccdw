/* -------------------------------------------------------- *
 *
 * Object Name: local.Update_CCP_Students
 * Object Type: Procedure
 * Creation Date: 2019-08-06
 *
 * Description: Creates amd Updates local.CCP_Students_Data.
 *
 * Change log: 
 *     20190806 DMO New
 *     20191127 DMO Changed from Term Start Date check from 1 month out to 2 months out
 *
 * -------------------------------------------------------- */
/* */
IF OBJECT_ID('local.Update_CCP_Students') IS NOT NULL
    DROP PROCEDURE local.Update_CCP_Students
GO

CREATE PROCEDURE local.Update_CCP_Students AS 
-- */

    -- Delete the table. We will rebuild the table on update.
    IF OBJECT_ID('local.CCP_Students_Data') IS NOT NULL
        DROP TABLE local.CCP_Students_Data;

    -- Drop the temporary table,if it exists.
    IF OBJECT_ID('#CCP_Students') IS NOT NULL
        DROP TABLE #CCP_Students;

    -- This code is needed to fix some records that are incorrect in the original database. 
    -- Some records are missing the commas between the end dates. This messes up the date 
    -- calculations in this view.

    -- This code requires the function RegEx_IsMatch4k from SQL# (http://sqlsharp.com), version 4.2. 
    -- It is part of the free download. The zip file can be found in ccdw/sql.
    UPDATE history.STUDENTS
    SET [STU.TYPE.END.DATES] = REPLACE([STU.TYPE.END.DATES],' ',', ')
        WHERE Sql#.RegEx_IsMatch4k( [STU.TYPE.END.DATES], '^(?:\s\d{4}-\d{2}-\d{2})+$', 1, '') > 0
    ;

    -- Create a temporary table for CCP_Students to be used below.
    -- This greatly reduces the time of the table build below.
    WITH 
        -- The most accurate data does back to 2008. Prior
        -- to that, the data is very suspect. Also, EC
        -- data does not go back further than 2007 anyway.
        Terms AS (
            SELECT *
            FROM dw_dim.Term_CU t
            WHERE t.Reporting_Year >= 2008
            AND t.Term_Start_Date <= DATEADD(MONTH,2,GETDATE()) /* @DMO C 20191127 */
        )
        -- Get attendance at the Early College. This will help distinguish
        -- which of the Student_Type = 'CCPP' are EC and which are CCP.
        -- Merge this with terms to create term-based records.
        , INSTITUTIONS_ATTEND_EC AS (
            SELECT DISTINCT
                   ia.[INSTA.PERSON.ID] AS Student_ID
                 , ia_da.[INSTA.START.DATES] AS Institution_Start_Date
                 , ia_da.[INSTA.END.DATES] AS Institution_End_Date
                 , t.Term_ID
              FROM history.INSTITUTIONS_ATTEND_Current ia
             INNER JOIN history.INSTITUTIONS_ATTEND__DATES_ATTENDED ia_da
                   ON (ia_da.[INSTA.INSTITUTIONS.ID] = ia.[INSTA.INSTITUTIONS.ID]
                   AND ia_da.[INSTA.PERSON.ID] = ia.[INSTA.PERSON.ID]
                   AND ia_da.EffectiveDatetime = ia.EffectiveDatetime
                   AND ia_da.ItemNumber = 1)
             INNER JOIN history.PERSON_Current p
                   ON p.ID = ia.[INSTA.PERSON.ID]
             -- This table holds the valid institutions for this person. There
             -- may be more institutions in the INSTITUTIONS_ATTEND table for
             -- this student, but they are no longer valid.
             INNER JOIN history.PERSON__INSTITUTIONS_ATTEND p_ia
                   ON p_ia.ID = p.ID
                   AND p_ia.[PERSON.INSTITUTIONS.ATTEND] = ia.[INSTA.INSTITUTIONS.ID]
                   AND p_ia.EffectiveDatetime = p.EffectiveDatetime
             INNER JOIN Terms t
                   ON (t.Term_Start_Date >= ia_da.[INSTA.START.DATES]
                   AND t.Term_End_Date   <= ia_da.[INSTA.END.DATES] )
             WHERE ia.[INSTA.INSTITUTIONS.ID] = '1113888' -- Haywood Early College
        )
        -- First, get list of all CCP and EC students. Right now (2019-08-06),
        -- these all share the Student_Type = 'CCPP'.
        -- NOTE: Cannot use STUDENTS_Current here as we need to go back
        --       in time for previous years to pick up prior CCP students.
        , CCP_Students_Base AS (
            SELECT DISTINCT
                s.[STUDENTS.ID] AS Student_ID
                , sst.[STU.TYPES] AS Student_Type
                , sst.[STU.TYPE.DATES] Student_Type_Start_Date
                , sst.[STU.TYPE.END.DATES] AS Student_Type_End_Date
                , s.EffectiveDatetime
            FROM history.STUDENTS s
            INNER JOIN history.STUDENTS__STU_TYPES sst
                ON sst.[STUDENTS.ID] = s.[STUDENTS.ID]
                AND sst.EffectiveDatetime = s.EffectiveDatetime
            WHERE sst.[STU.TYPES] = 'CCPP'
        )
        -- Get the most recent record as this is the most current.
        -- Cannot use STUDENTS_Current above as we need to go back
        -- in time for previous years to pick up prior CCP students.
        , CCP_Students_Base_Max AS (
            SELECT Student_ID 
                , Student_Type
                , MAX(EffectiveDatetime) AS Max_EffectiveDatetime
            FROM CCP_Students_Base sst
            GROUP BY Student_ID, Student_Type
        )
        -- Now merge the above two tables together with Terms to create term-based
        -- records. Use the INSTITUTIONS_ATTEND to separate EC from CCP.
        , CCP_Students AS (
            SELECT csb.Student_ID
                , t.Term_ID
                , CASE WHEN iaec.Institution_Start_Date IS NOT NULL THEN 'EC' ELSE 'CCP' END AS Student_Type
                , csb.Student_Type_Start_Date
                , CASE WHEN csb.Student_Type_End_Date = CAST('9999-12-31' AS DATE)
                            THEN NULL
                       ELSE csb.Student_Type_End_Date END AS Student_Type_End_Date 
            FROM CCP_Students_Base csb
            INNER JOIN CCP_Students_Base_Max csbm
                ON csbm.Student_ID = csb.Student_ID
                AND csbm.Student_Type = csb.Student_Type
                AND csbm.Max_EffectiveDatetime = csb.EffectiveDatetime
            LEFT JOIN Terms t
                ON (
                    (    csb.Student_Type_Start_Date  < t.Term_End_Date
                        AND csb.Student_Type_End_Date > t.Term_Start_Date  )
                    )
            LEFT JOIN INSTITUTIONS_ATTEND_EC iaec
                ON (iaec.Student_ID = csb.Student_ID
                AND iaec.Term_ID = t.Term_ID)
        )
        SELECT * 
          INTO #CCP_Students
          FROM CCP_Students
    ;

    WITH 
        -- The most accurate data does back to 2008. Prior
        -- to that, the data is very suspect. Also, EC
        -- data does not go back further than 2007 anyway.
        Terms AS (
            SELECT *
              FROM dw_dim.Term_CU t
             WHERE t.Reporting_Year >= 2008
               AND t.Term_Start_Date <= DATEADD(MONTH,2,GETDATE()) /* @DMO C 20191127 */
        )
        -- Get graduation records for all the students. We 
        -- want to know whether the student graduated from 
        -- this program or not.
        /* 
         * See note below on Student_Programs.
         *
         * , ACAD_CREDENTIALS AS (
         *     SELECT ac.[ACAD.PERSON.ID] AS Student_ID
         *          , ac.[ACAD.ACAD.PROGRAM] AS Program_Code
         *          , MAX(ac.[ACAD.CAST.DATE]) AS Graduation_Date
         *       FROM history.ACAD_CREDENTIALS ac
         *      WHERE ac.[ACAD.INSTITUTIONS.ID] = '0019844'
         *      GROUP BY ac.[ACAD.PERSON.ID], ac.[ACAD.ACAD.PROGRAM]
         * )
         */
        , APPLICATIONS AS (
            SELECT a.[APPL.APPLICANT] AS Student_ID
                 , a.[APPL.START.TERM] AS Term_ID
                 , 'Applied' AS Application_Status
                 , CASE WHEN a.[APPL.STATUS] = 'AD' 
                             THEN 'Admitted'
                        ELSE 'Not Admitted' END AS Admission_Status
              FROM history.APPLICATIONS_Current a 
        )
        -- Get Enrollment Records for all the students to know whether
        -- students are enrolled in a particular term and for 
        -- matriculation data.
        , STUDENT_ACAD_CRED AS (
            SELECT DISTINCT 
                   sac.[STC.PERSON.ID] AS Student_ID
                 , sac.[STC.TERM] AS Term_ID
                 , 'Yes' AS Enrolled
              FROM history.STUDENT_ACAD_CRED_Current sac
             INNER JOIN Terms t
                   ON (sac.[STC.TERM] = t.Term_ID)
             WHERE sac.[STC.STATUS] IN ('A','N','W')
               AND sac.[STC.ACAD.LEVEL] = 'CU'
        )
        -- Use the user-defined table to determine which programs
        -- are CCP and which are EC.
        , CCP_Programs AS (
            SELECT DISTINCT
                   ap_u.[USER.ACPG.PROGRAMS.ID] AS Program_Code
                 , ap_u.[USER.ACPG.ALTERNATE_GROUP_CODE] AS Program_Group_Code
              FROM history.ACAD_PROGRAMS__USER_Current ap_u
             WHERE ap_u.[USER.ACPG.ALTERNATE_GROUP_CODE] IN ('CCP','EC')
        )
        /* 
         * This creates a cyclical redundancy with Student_Programs.
         * This is not necessary here so remove it in the future.
         *
         * -- Get student programs data (which is term-base) 
         * , CCP_Student_Programs AS (
         *     SELECT sp.[Student ID] AS Student_ID
         *          , sp.[Program Code] AS Program_Code
         *          , COALESCE(ccpp.Program_Group_Code,'OTH') AS Program_Group_Code
         *          , sp.Term_ID
         *          , sp.[Program Start Date] AS Program_Start_Date
         *          , sp.[Program End Date] AS Program_End_Date
         *       FROM local.Student_Programs_Data sp
         *       LEFT JOIN CCP_Programs ccpp
         *            ON (ccpp.Program_Code = sp.[Program Code])
         * )
         */
        , CCP_Pathways AS (
              SELECT xp.[XNC.PERSON.ID] AS Student_ID
                   , xp.[XNC.PATHWAY.TYPE] AS Pathway_Type
                   , xp.[XNC.PATHWAY.ENTRY] AS Pathway_Entry
                   , CASE WHEN COALESCE(xp.[XNC.PATHWAY.END.DATE],'') <> '' 
                               THEN CAST(DATEADD(YEAR, 
                                                 CASE WHEN xp.[XNC.PATHWAY.TYPE] = 'CIE' THEN -1 ELSE 0 END
                                                 + CASE WHEN xp.[XNC.PATHWAY.ENTRY] = 'FR' THEN -4
                                                        WHEN xp.[XNC.PATHWAY.ENTRY] = 'SO' THEN -3
                                                        WHEN xp.[XNC.PATHWAY.ENTRY] = 'JU' THEN -2
                                                        WHEN xp.[XNC.PATHWAY.ENTRY] = 'SR' THEN -1
                                                        ELSE 0 END,
                                                 xp.[XNC.PATHWAY.END.DATE]) AS DATE) 
                          ELSE NULL END AS Pathway_Start_Date
                   , CASE WHEN COALESCE(xp.[XNC.PATHWAY.END.DATE],'') = ''
                               THEN NULL
                          ELSE xp.[XNC.PATHWAY.END.DATE] END AS Pathway_End_Date
                   , CASE WHEN COALESCE(xp.[XNC.HS.LAST.ATTENDED.DATE],'') = ''
                               THEN NULL -- ia_hs.HS_End_Date
                          ELSE xp.[XNC.HS.LAST.ATTENDED.DATE] END AS Last_HS_Attend_Date
              FROM history.XNC_PERSON_Current xp
             WHERE [XNC.PATHWAY.TYPE] in ('CIE','CTE','CTP')
        )
        -- Put the pieces together.
        -- A student is 
        -- Steps to determine if a student is CCP or EC:
        --    . If the student is in CTP or CTE, then assign them CCP; if in CIE, assign them EC;
        --    . If student is in a CCP or EC program, then assign then accordingly
        --    . If student is not in a CCP or EC program but does have a STU.TYPES == ‘CCPP’, then assign them as follows:
        --        - If student is active in the early college (INSTA.INSTITUTIONS.ID == ‘1113888’), then assign as EC
        --        - If student is NOT active in the early college, then assign as CCP
        --    . If student is not in CCP or EC program nor do they have a STU.TYPE == ‘CCPP’ then assign them as Non-CCP.

        , CCP_Students AS (
            SELECT ccp.Student_ID
                 , ccp.Term_ID
                 , t.Academic_Year
                 , CASE WHEN COALESCE(ccpp.Pathway_Type,'') IN ('CTE','CTP') THEN 'CCP'
                        WHEN COALESCE(ccpp.Pathway_Type,'') = 'CIE' THEN 'EC'
                        --WHEN COALESCE(csp.Program_Group_Code,'OTH') = 'OTH' AND sace.Enrolled = 'Yes' THEN ccp.Student_Type
                        --ELSE COALESCE(csp.Program_Group_Code,'OTH') 
                        ELSE 'OTH' END AS Student_Type
                 , ccp.Student_Type_Start_Date
                 , ccp.Student_Type_End_Date
                 /*
                  * See note above.
                  *
                  * , csp.Program_Code
                  * , csp.Program_Start_Date
                  * , csp.Program_End_Date
                  * , CASE WHEN ac.Graduation_Date IS NULL THEN 'No' ELSE 'Yes' END AS Graduated_From_Program
                  */
                 , COALESCE(sace.Enrolled,'No') AS Enrolled_This_Term
                 , ccpp.Pathway_Type
                 , ccpp.Pathway_Entry
                 , ccpp.Pathway_Start_Date
                 , ccpp.Pathway_End_Date
              FROM #CCP_Students ccp
              LEFT JOIN CCP_Pathways ccpp
                   ON ccpp.Student_ID = ccp.Student_ID
              /* 
               * See note above.
               *
               * LEFT JOIN CCP_Student_Programs csp
               *      ON (csp.Student_ID = ccp.Student_ID
               *      AND csp.Term_ID = ccp.Term_ID)
               */
             INNER JOIN Terms t
                   ON (t.Term_ID = ccp.Term_ID)
              LEFT JOIN STUDENT_ACAD_CRED sace
                   ON (sace.Student_ID = ccp.Student_ID
                   AND sace.Term_ID = ccp.Term_ID)
              /* 
               * See note above.
               *
               * LEFT JOIN ACAD_CREDENTIALS ac
               *      ON ac.Student_ID = csp.Student_ID
               *      AND ac.Program_Code = csp.Program_Code
               */
        )
        , CCP_Terms AS (
            SELECT ccp.Student_ID
                 , MIN(t.Term_Start_Date) AS First_CCP_Term_Start_Date
                 , MAX(t.Term_End_Date) AS Last_CCP_Term_End_Date
              FROM CCP_Students ccp
              LEFT JOIN Terms t
                   ON (t.Term_ID = ccp.Term_ID)
             WHERE ccp.Enrolled_This_Term = 'Yes'
             GROUP BY ccp.Student_ID
        )
        -- Keep only the CCP and EC students
        SELECT DISTINCT
               ccp.Student_ID
             , ccp.Term_ID
             , ccp.Academic_Year
             , ccp.Student_Type
             , ccp.Student_Type_Start_Date
             , ccp.Student_Type_End_Date
              /* 
               * See note above.
               *
               * , ccp.Program_Code
               * , ccp.Program_Start_Date
               * , ccp.Program_End_Date
               * , ccp.Graduated_From_Program
               */
             , ccp.Enrolled_This_Term
             , ccp.Pathway_Type
             , ccp.Pathway_Entry
             , ccp.Pathway_Start_Date
             , ccp.Pathway_End_Date
             , ft.Academic_Year AS Cohort_Academic_Year
             , ccpt.First_CCP_Term_Start_Date
             , lt.Academic_Year AS Terminal_Academic_Year
             , ccpt.Last_CCP_Term_End_Date
             , COALESCE(a.Application_Status,'Not Applied') AS Application_Status
             , COALESCE(a.Admission_Status,'Returning/Continuing') AS Admission_Status
          INTO local.CCP_Students_Data 
          FROM CCP_Students ccp
          LEFT JOIN CCP_Terms ccpt
               ON ccpt.Student_ID = ccp.Student_ID
          LEFT JOIN APPLICATIONS a 
               ON (a.Student_ID = ccp.Student_ID
               AND a.Term_ID = ccp.Term_ID)
          LEFT JOIN Terms ft 
               ON ft.Term_Start_Date = ccpt.First_CCP_Term_Start_Date
          LEFT JOIN Terms lt 
               ON lt.Term_End_Date = ccpt.Last_CCP_Term_End_Date
         WHERE ccp.Student_Type IN ('CCP','EC')
    ;

    -- Drop the temporary tables.
    DROP TABLE #CCP_Students;

GO
/* *


SELECT csd.Academic_Year
     , csd.Term_ID
     , csd.Student_ID
     , csd.Student_Type
     , csd.Student_Type_Start_Date
     , csd.Student_Type_End_Date
     --, csd.Program_Code
     --, csd.Program_Start_Date
     --, csd.Program_End_Date
     --, csd.Graduated_From_Program
     , csd.Enrolled_This_Term
     , csd.Cohort_Academic_Year
     , csd.First_CCP_Term_Start_Date
     , csd.Terminal_Academic_Year
     , csd.Last_CCP_Term_End_Date
     , csd.Pathway_Type
     , csd.Pathway_Entry
     , csd.Pathway_Start_Date
     , csd.Pathway_End_Date
     , csd.Application_Status
     , csd.Admission_Status
  FROM local.CCP_Students_Data csd
 WHERE csd.Academic_Year = '2018-2019'
 ORDER BY csd.Academic_Year, csd.Student_ID, csd.Term_ID, csd.Pathway_Start_Date

-- */

/* */

EXEC local.Update_CCP_Students;

-- */
