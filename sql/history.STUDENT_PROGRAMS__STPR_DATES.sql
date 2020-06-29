IF OBJECT_ID('history.STUDENT_PROGRAMS__STPR_DATES', 'V') IS NOT NULL
    DROP VIEW history.STUDENT_PROGRAMS__STPR_DATES
GO

CREATE VIEW history.STUDENT_PROGRAMS__STPR_DATES AS
    SELECT [STPR.ACAD.PROGRAM]
         , [STPR.STUDENT]
         , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA1.Item)),'') = '' THEN NULL 
                     ELSE LTRIM(RTRIM(CA1.Item)) END AS DATE) AS [STPR.START.DATE]
         , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA2.Item)),'') = '' THEN NULL 
                     ELSE LTRIM(RTRIM(CA2.Item)) END AS DATE) AS [STPR.END.DATE]
         , CA1.ItemNumber AS ItemNumber
         , EffectiveDatetime
      FROM [history].[STUDENT_PROGRAMS]
     CROSS APPLY dbo.DelimitedSplit8K([STPR.START.DATE], ', ') CA1
     CROSS APPLY dbo.DelimitedSplit8K([STPR.END.DATE], ', ') CA2
     WHERE COALESCE ([STPR.START.DATE], '') != '' AND CA1.ItemNumber = CA2.ItemNumber
;