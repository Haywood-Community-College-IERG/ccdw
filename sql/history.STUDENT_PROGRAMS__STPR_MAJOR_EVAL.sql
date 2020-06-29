IF OBJECT_ID('history.STUDENT_PROGRAMS__STPR_MAJOR_EVAL', 'V') IS NOT NULL
    DROP VIEW history.STUDENT_PROGRAMS__STPR_MAJOR_EVAL
GO

CREATE VIEW history.STUDENT_PROGRAMS__STPR_MAJOR_EVAL AS
    SELECT [STPR.ACAD.PROGRAM]
         , [STPR.STUDENT]
         , CASE WHEN COALESCE(LTRIM(RTRIM(CA1.Item)),'') = '' THEN NULL 
                ELSE LTRIM(RTRIM(CA1.Item)) END AS [STPR.EVAL.MAJORS]
         , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA2.Item)),'') = '' THEN NULL 
                     ELSE LTRIM(RTRIM(CA2.Item)) END AS NUMERIC(9,2)) / 1000 AS [STPR.EVAL.MAJOR.CRED.TOT]
         , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA3.Item)),'') = '' THEN NULL 
                     ELSE LTRIM(RTRIM(CA3.Item)) END AS NUMERIC(7,3)) / 100 AS [STPR.EVAL.MAJOR.GPA]
         , CASE WHEN COALESCE(LTRIM(RTRIM(CA4.Item)),'') = '' THEN NULL 
                ELSE LTRIM(RTRIM(CA4.Item)) END AS [STPR.EVAL.MAJOR.STATUS]
         , CA1.ItemNumber AS ItemNumber
         , EffectiveDatetime
      FROM [history].[STUDENT_PROGRAMS]
     CROSS APPLY dbo.DelimitedSplit8K([STPR.EVAL.MAJORS], ', ') CA1
     CROSS APPLY dbo.DelimitedSplit8K([STPR.EVAL.MAJOR.CRED.TOT], ', ') CA2
     CROSS APPLY dbo.DelimitedSplit8K([STPR.EVAL.MAJOR.GPA], ', ') CA3
     CROSS APPLY dbo.DelimitedSplit8K([STPR.EVAL.MAJOR.STATUS], ', ') CA4
     WHERE COALESCE ([STPR.EVAL.MAJORS], '') != '' 
       AND CA1.ItemNumber = CA2.ItemNumber
       AND CA1.ItemNumber = CA3.ItemNumber
       AND CA1.ItemNumber = CA4.ItemNumber
;