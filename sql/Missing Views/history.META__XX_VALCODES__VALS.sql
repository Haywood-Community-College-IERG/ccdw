SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP VIEW [history].[META__CF_VALCODES__VALS]
GO
CREATE VIEW [history].[META__CF_VALCODES__VALS] AS
SELECT [VALCODE.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(25)) AS [VAL.EXTERNAL.REPRESENTATION]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(10)) AS [VAL.INTERNAL.CODE]
, CAST(LTRIM(RTRIM(CA3.Item)) AS VARCHAR(10)) AS [VAL.MINIMUM.INPUT.STRING]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__CF_VALCODES]
  
CROSS APPLY dw_util.DelimitedSplit8K([VAL.EXTERNAL.REPRESENTATION],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([VAL.INTERNAL.CODE],', ') CA2
CROSS APPLY dw_util.DelimitedSplit8K([VAL.MINIMUM.INPUT.STRING],', ') CA3
 WHERE COALESCE([VAL.EXTERNAL.REPRESENTATION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
AND CA1.ItemNumber=CA3.ItemNumber
GO


DROP VIEW [history].[META__CORE_VALCODES__VALS]
GO
CREATE VIEW [history].[META__CORE_VALCODES__VALS] AS
SELECT [VALCODE.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(25)) AS [VAL.EXTERNAL.REPRESENTATION]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(10)) AS [VAL.INTERNAL.CODE]
, CAST(LTRIM(RTRIM(CA3.Item)) AS VARCHAR(10)) AS [VAL.MINIMUM.INPUT.STRING]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__CORE_VALCODES]
  
CROSS APPLY dw_util.DelimitedSplit8K([VAL.EXTERNAL.REPRESENTATION],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([VAL.INTERNAL.CODE],', ') CA2
CROSS APPLY dw_util.DelimitedSplit8K([VAL.MINIMUM.INPUT.STRING],', ') CA3
 WHERE COALESCE([VAL.EXTERNAL.REPRESENTATION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
AND CA1.ItemNumber=CA3.ItemNumber
GO


DROP VIEW [history].[META__HR_VALCODES__VALS]
GO
CREATE VIEW [history].[META__HR_VALCODES__VALS] AS
SELECT [VALCODE.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(25)) AS [VAL.EXTERNAL.REPRESENTATION]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(10)) AS [VAL.INTERNAL.CODE]
, CAST(LTRIM(RTRIM(CA3.Item)) AS VARCHAR(10)) AS [VAL.MINIMUM.INPUT.STRING]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__HR_VALCODES]
  
CROSS APPLY dw_util.DelimitedSplit8K([VAL.EXTERNAL.REPRESENTATION],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([VAL.INTERNAL.CODE],', ') CA2
CROSS APPLY dw_util.DelimitedSplit8K([VAL.MINIMUM.INPUT.STRING],', ') CA3
 WHERE COALESCE([VAL.EXTERNAL.REPRESENTATION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
AND CA1.ItemNumber=CA3.ItemNumber
GO


DROP VIEW [history].[META__ST_VALCODES__VALS]
GO
CREATE VIEW [history].[META__ST_VALCODES__VALS] AS
SELECT [VALCODE.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(25)) AS [VAL.EXTERNAL.REPRESENTATION]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(10)) AS [VAL.INTERNAL.CODE]
, CAST(LTRIM(RTRIM(CA3.Item)) AS VARCHAR(10)) AS [VAL.MINIMUM.INPUT.STRING]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__ST_VALCODES]
  
CROSS APPLY dw_util.DelimitedSplit8K([VAL.EXTERNAL.REPRESENTATION],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([VAL.INTERNAL.CODE],', ') CA2
CROSS APPLY dw_util.DelimitedSplit8K([VAL.MINIMUM.INPUT.STRING],', ') CA3
 WHERE COALESCE([VAL.EXTERNAL.REPRESENTATION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
AND CA1.ItemNumber=CA3.ItemNumber
GO


DROP VIEW [history].[META__TOOL_VALCODES__VALS]
GO
CREATE VIEW [history].[META__TOOL_VALCODES__VALS] AS
SELECT [VALCODE.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(25)) AS [VAL.EXTERNAL.REPRESENTATION]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(10)) AS [VAL.INTERNAL.CODE]
, CAST(LTRIM(RTRIM(CA3.Item)) AS VARCHAR(10)) AS [VAL.MINIMUM.INPUT.STRING]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__TOOL_VALCODES]
  
CROSS APPLY dw_util.DelimitedSplit8K([VAL.EXTERNAL.REPRESENTATION],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([VAL.INTERNAL.CODE],', ') CA2
CROSS APPLY dw_util.DelimitedSplit8K([VAL.MINIMUM.INPUT.STRING],', ') CA3
 WHERE COALESCE([VAL.EXTERNAL.REPRESENTATION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
AND CA1.ItemNumber=CA3.ItemNumber
GO


DROP VIEW [history].[META__UT_VALCODES__VALS]
GO
CREATE VIEW [history].[META__UT_VALCODES__VALS] AS
SELECT [VALCODE.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(25)) AS [VAL.EXTERNAL.REPRESENTATION]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(10)) AS [VAL.INTERNAL.CODE]
, CAST(LTRIM(RTRIM(CA3.Item)) AS VARCHAR(10)) AS [VAL.MINIMUM.INPUT.STRING]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__UT_VALCODES]
  
CROSS APPLY dw_util.DelimitedSplit8K([VAL.EXTERNAL.REPRESENTATION],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([VAL.INTERNAL.CODE],', ') CA2
CROSS APPLY dw_util.DelimitedSplit8K([VAL.MINIMUM.INPUT.STRING],', ') CA3
 WHERE COALESCE([VAL.EXTERNAL.REPRESENTATION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
AND CA1.ItemNumber=CA3.ItemNumber
GO