/* 
IF OBJECT_ID('local.CohortEnrollment', 'V') IS NOT NULL
    DROP VIEW local.CohortEnrollment
GO

CREATE VIEW local.CohortEnrollment AS
*/
WITH terms AS (
	SELECT *
	  FROM dw_dim.Term_CU dt
	 WHERE dt.Term_End_Date < CURRENT_TIMESTAMP
	   AND dt.Term_Index >= 20000
--	   AND Term_Abbreviation <> 'SU'
), first_term AS (
    SELECT scs.Student_ID 
   	     , MIN(t.Term_Index) AS Min_Term_Index
      FROM local.StudentCreditsAndStatus scs
      JOIN terms t ON (t.Term_ID = scs.Term_ID)
     GROUP BY scs.Student_ID
), first_term_adj AS (
    SELECT sp.Student_ID
         , sp.Min_Term_Index AS First_Term_Index
         , sp.Min_Term_Index AS Cohort_Term_Index
      FROM first_term sp
     WHERE SUBSTRING(CAST(sp.Min_Term_Index AS VARCHAR), 5, 1) IN ('1', '6')

    UNION

    SELECT Student_ID 
         , Min_Term_Index AS First_Term_Index
         , CASE WHEN Min_Term_Index_FA IS NULL 
                    THEN Min_Term_Index
                ELSE Min_Term_Index_FA END AS Cohort_Term_Index
      FROM (
            SELECT ft.Student_ID 
  		         , ft.Min_Term_Index AS Min_Term_Index
                 , ft_fa.Min_Term_Index AS Min_Term_Index_FA
 	          FROM first_term ft
              LEFT JOIN first_term ft_fa
                   ON (ft_fa.Student_ID = ft.Student_ID
                       AND ft_fa.Min_Term_Index = ft.Min_Term_Index+3)
             WHERE SUBSTRING(CAST(ft.Min_Term_Index AS VARCHAR), 5, 1) = '3'
           ) scs
), st AS (
	SELECT DISTINCT
	       [STTR.STUDENT]
		 , [STTR.TERM]
	  FROM history.STUDENT_TERMS_Current st
	 WHERE st.[STTR.STATUS] NOT IN ('X','W','N','S')
), st_all_terms AS (
	SELECT st.[STTR.STUDENT] AS Student_ID
	     , terms.Term_ID
		 , terms.Term_Start_Date
		 , terms.Term_End_Date
	  FROM (SELECT DISTINCT [STTR.STUDENT] FROM st) AS st
	 CROSS JOIN terms
), sal_terms AS (
	SELECT [STA.STUDENT]
		 , [STA.ACAD.LEVEL]
		 , LTRIM(RTRIM(CA1.Item)) AS [STA.TERM]
		 , CA1.ItemNumber AS ItemNumber
		 , EffectiveDatetime
	  FROM history.STUDENT_ACAD_LEVELS 
	 CROSS APPLY dw_util.DelimitedSplit8K([STA.TERMS], ', ') CA1 
	 WHERE COALESCE ([STA.TERMS], '') != '' 
), sal AS (
	SELECT sal.[STA.STUDENT]
	     , sal_terms.[STA.TERM]
	     , sal.[STA.FED.COHORT.GROUP]
		 , CASE WHEN COALESCE(sal.[STA.FED.COHORT.GROUP],'') = '' THEN NULL
		        ELSE SUBSTRING(sal.[STA.FED.COHORT.GROUP], 1, 4) + 'FA' END AS [STA.FED.COHORT.TERM]
		 , CASE WHEN COALESCE(sal.[STA.FED.COHORT.GROUP],'') = '' THEN NULL
		        ELSE SUBSTRING(sal.[STA.FED.COHORT.GROUP], 5, 2) END AS [STA.FED.COHORT.ENROLLMENT]
	  FROM history.STUDENT_ACAD_LEVELS_Current sal
	  JOIN sal_terms
	       ON (sal_terms.[STA.STUDENT] = sal.[STA.STUDENT]
		       AND sal_terms.[STA.ACAD.LEVEL] = sal.[STA.ACAD.LEVEL]
			   AND sal_terms.EffectiveDatetime = sal.EffectiveDatetime)
	 WHERE sal.[STA.ACAD.LEVEL] = 'CU'
	   AND SUBSTRING(sal.[STA.FED.COHORT.GROUP],1,4) != '2010'
), grads AS (
	SELECT DISTINCT
		   [ACAD.PERSON.ID] AS Student_ID
		  ,[ACAD.TERM] AS Term_ID
	  FROM [IERG].[history].[ACAD_CREDENTIALS_Current]
	  WHERE COALESCE([ACAD.TERM],'') != ''
		AND [ACAD.INSTITUTIONS.ID] = '0019844'
), cohorts AS (
	SELECT sal.[STA.STUDENT] AS Student_ID
		 , sal.[STA.TERM] AS Term_ID
		 , sal.[STA.FED.COHORT.GROUP] AS Cohort_Group
		 , sal.[STA.FED.COHORT.TERM] AS Cohort_Term
		 , sal.[STA.FED.COHORT.ENROLLMENT] AS Cohort_Enrollment
		 , tc.Term_Start_Date AS Cohort_Start_Date
	  FROM sal
	 INNER JOIN st 
		   ON ([STA.STUDENT] = [STTR.STUDENT]
			   AND [STA.TERM] = [STTR.TERM])
	 INNER JOIN terms AS tsal
		   ON (tsal.Term_ID = [STA.TERM])
	 INNER JOIN terms AS tc
		   ON (tc.Term_ID = [STA.FED.COHORT.TERM])
	 WHERE sal.[STA.FED.COHORT.TERM] IS NOT NULL
)
SELECT st.Student_ID
     , st.Term_ID
	 , st.Term_Start_Date
	 , st.Term_End_Date
	 , COALESCE(ct.Term_ID, st.Term_ID) AS Term_ID_2
	 , ft.First_Term_Index
     , ft.Cohort_Term_Index
     , c.Cohort_Term
	 -- , c.Cohort_Group
	 , c.Cohort_Enrollment
	 --, c.Cohort_Start_Date
	 , credits.Credits
	 , credits.[Completed Credits]
	 , credits.[Enrollment Status - Census]
	 , credits.[Enrollment Status - EOT]
	 , CASE WHEN grads.Term_ID IS NOT NULL THEN 'Y' ELSE '' END AS Graduation_Term
  FROM st_all_terms st
  LEFT JOIN first_term_adj ft
       ON (ft.Student_ID = st.Student_ID)
  LEFT JOIN cohorts ct
       ON (ct.Student_ID = st.Student_ID
	       AND ct.Term_ID = st.Term_ID)
  LEFT JOIN (SELECT DISTINCT
                    c2.Student_ID
                  , c2.Cohort_Term
				  , c2.Cohort_Group
				  , c2.Cohort_Enrollment
				  , c2.Cohort_Start_Date
               FROM cohorts c2) c
       ON (c.Student_ID = st.Student_ID)
  LEFT JOIN local.StudentCreditsAndStatus credits
       ON (credits.Student_ID = st.Student_ID
	       AND credits.Term_ID = st.Term_ID)
  LEFT JOIN grads
       ON (grads.Student_ID = st.Student_ID
	       AND grads.Term_ID = st.Term_ID)
 WHERE st.Term_Start_Date >= COALESCE(c.Cohort_Start_Date, st.Term_Start_Date)
   AND st.Term_Start_Date >= COALESCE(ft.First_Term_Start_Date, st.Term_Start_Date)
   AND ft.First_Term_ID IS NOT NULL
 -- st.Term_Start_Date >= c.Cohort_Start_Date
ORDER BY 1, 3
