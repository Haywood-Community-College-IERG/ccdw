USE [IERG]
GO
/****** Object:  View [history].[XLE_STUDENTS__XLE_TEST]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[XLE_STUDENTS__XLE_TEST] AS
SELECT [XLE.STUDENTS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(30)) AS [XLE.TEST.CODE]
, CAST(LTRIM(RTRIM(CA2.Item)) AS DATE) AS [XLE.TEST.DATE]
, CAST(LTRIM(RTRIM(CA3.Item)) AS NUMERIC(6,1)) AS [XLE.TEST.SCORE]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[XLE_STUDENTS]
  
 CROSS APPLY dbo.DelimitedSplit8K([XLE.TEST.CODE],', ') CA1
 CROSS APPLY dbo.DelimitedSplit8K([XLE.TEST.DATE],', ') CA2
 CROSS APPLY dbo.DelimitedSplit8K([XLE.TEST.SCORE],', ') CA3
 WHERE COALESCE([XLE.TEST.CODE],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
AND CA1.ItemNumber=CA3.ItemNumber

GO
