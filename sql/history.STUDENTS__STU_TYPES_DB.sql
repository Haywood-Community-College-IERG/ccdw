SELECT [STUDENTS.ID]
     , LTRIM(RTRIM(CA1.Item)) AS [STU.TYPES]
     , CAST(LTRIM(RTRIM(CA2.Item)) AS DATE) AS [STU.TYPE.DATES]
     
     /* Fix blank and NULL dates to default to far in the future*/ 
     , CAST(CASE WHEN COALESCE (LTRIM(RTRIM(CA3.Item)), '') = '' THEN '9999-12-31' ELSE LTRIM(RTRIM(CA3.Item)) END AS DATE) AS [STU.TYPE.END.DATES]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
FROM            [history].[STUDENTS] 
CROSS APPLY dbo.DelimitedSplit8K([STU.TYPES], ', ') CA1 
CROSS APPLY dbo.DelimitedSplit8K([STU.TYPE.DATES], ', ') CA2 
CROSS APPLY dbo.DelimitedSplit8K([STU.TYPE.END.DATES], ', ') CA3
WHERE        COALESCE ([STU.TYPES], '') != '' 
AND CA1.ItemNumber = CA2.ItemNumber 
AND CA1.ItemNumber = CA3.ItemNumber;