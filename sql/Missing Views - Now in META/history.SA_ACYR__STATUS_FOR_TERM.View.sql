SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP VIEW [history].[SA_ACYR__STATUS_FOR_TERM]
GO
CREATE VIEW [history].[SA_ACYR__STATUS_FOR_TERM] AS
SELECT [SA.STUDENT.ID]
, [SA.YEAR]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS NUMERIC(7, 2)) AS [SA.MBA]
, CAST(LTRIM(RTRIM(CA2.Item)) AS NUMERIC(7, 2)) AS [SA.MBA.USED]
, CAST(LTRIM(RTRIM(CA3.Item)) AS VARCHAR(7)) AS [SA.TERMS]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[SA_ACYR]
  
CROSS APPLY dw_util.DelimitedSplit8K([SA.MBA],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([SA.MBA.USED],', ') CA2
CROSS APPLY dw_util.DelimitedSplit8K([SA.TERMS],', ') CA3
 WHERE COALESCE([SA.TERMS],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
AND CA1.ItemNumber=CA3.ItemNumber
GO
