SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('history.[META__ALL_SECLASS]', 'V') IS NOT NULL
    DROP VIEW history.[META__ALL_SECLASS]
GO

CREATE VIEW history.[META__ALL_SECLASS] AS
SELECT 'CF' AS CDDFILE,
       *       
  FROM history.[META__CF_SECLASS]
UNION
SELECT 'CORE' AS CDDFILE,
       *
  FROM history.[META__CORE_SECLASS]
UNION
SELECT 'HR' AS CDDFILE,
       *
  FROM history.[META__HR_SECLASS]
UNION
SELECT 'ST' AS CDDFILE,
       *
  FROM history.[META__ST_SECLASS]
UNION
SELECT 'UT' AS CDDFILE,
       *
  FROM history.[META__UT_SECLASS]
GO

IF OBJECT_ID('history.[META__ALL_SECLASS_Current]', 'V') IS NOT NULL
    DROP VIEW history.[META__ALL_SECLASS_Current]
GO

CREATE VIEW history.[META__ALL_SECLASS_Current] AS
SELECT *       
  FROM history.[META__ALL_SECLASS] m
 WHERE m.CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__CF_SECLASS__DENY_ACCESS]
GO
CREATE VIEW [history].[META__CF_SECLASS__DENY_ACCESS] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [DENY.ACCESS.EXCEPT.TO.CLASS]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__CF_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([DENY.ACCESS.EXCEPT.TO.CLASS],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__CORE_SECLASS__DENY_ACCESS]
GO
CREATE VIEW [history].[META__CORE_SECLASS__DENY_ACCESS] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [DENY.ACCESS.EXCEPT.TO.CLASS]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__CORE_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([DENY.ACCESS.EXCEPT.TO.CLASS],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__HR_SECLASS__DENY_ACCESS]
GO
CREATE VIEW [history].[META__HR_SECLASS__DENY_ACCESS] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [DENY.ACCESS.EXCEPT.TO.CLASS]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__HR_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([DENY.ACCESS.EXCEPT.TO.CLASS],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__ST_SECLASS__DENY_ACCESS]
GO
CREATE VIEW [history].[META__ST_SECLASS__DENY_ACCESS] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [DENY.ACCESS.EXCEPT.TO.CLASS]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__ST_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([DENY.ACCESS.EXCEPT.TO.CLASS],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__UT_SECLASS__DENY_ACCESS]
GO
CREATE VIEW [history].[META__UT_SECLASS__DENY_ACCESS] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [DENY.ACCESS.EXCEPT.TO.CLASS]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__UT_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([DENY.ACCESS.EXCEPT.TO.CLASS],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__ALL_SECLASS__DENY_ACCESS]
GO
CREATE VIEW history.[META__ALL_SECLASS__DENY_ACCESS] AS
SELECT 'CF' AS CDDFILE,
       *       
  FROM history.[META__CF_SECLASS__DENY_ACCESS]
UNION
SELECT 'CORE' AS CDDFILE,
       *
  FROM history.[META__CORE_SECLASS__DENY_ACCESS]
UNION
SELECT 'HR' AS CDDFILE,
       *
  FROM history.[META__HR_SECLASS__DENY_ACCESS]
UNION
SELECT 'ST' AS CDDFILE,
       *
  FROM history.[META__ST_SECLASS__DENY_ACCESS]
UNION
SELECT 'UT' AS CDDFILE,
       *
  FROM history.[META__UT_SECLASS__DENY_ACCESS]
GO

DROP VIEW [history].[META__CF_SECLASS__INQUIRY_ONLY]
GO
CREATE VIEW [history].[META__CF_SECLASS__INQUIRY_ONLY] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [INQUIRY.ONLY.PROCESS.LIST]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__CF_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([INQUIRY.ONLY.PROCESS.LIST],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__CORE_SECLASS__INQUIRY_ONLY]
GO
CREATE VIEW [history].[META__CORE_SECLASS__INQUIRY_ONLY] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [INQUIRY.ONLY.PROCESS.LIST]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__CORE_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([INQUIRY.ONLY.PROCESS.LIST],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__HR_SECLASS__INQUIRY_ONLY]
GO
CREATE VIEW [history].[META__HR_SECLASS__INQUIRY_ONLY] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [INQUIRY.ONLY.PROCESS.LIST]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__HR_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([INQUIRY.ONLY.PROCESS.LIST],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__ST_SECLASS__INQUIRY_ONLY]
GO
CREATE VIEW [history].[META__ST_SECLASS__INQUIRY_ONLY] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [INQUIRY.ONLY.PROCESS.LIST]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__ST_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([INQUIRY.ONLY.PROCESS.LIST],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__UT_SECLASS__INQUIRY_ONLY]
GO
CREATE VIEW [history].[META__UT_SECLASS__INQUIRY_ONLY] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [INQUIRY.ONLY.PROCESS.LIST]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__UT_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([INQUIRY.ONLY.PROCESS.LIST],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__ALL_SECLASS__INQUIRY_ONLY]
GO
CREATE VIEW history.[META__ALL_SECLASS__INQUIRY_ONLY] AS
SELECT 'CF' AS CDDFILE,
       *       
  FROM history.[META__CF_SECLASS__INQUIRY_ONLY]
UNION
SELECT 'CORE' AS CDDFILE,
       *
  FROM history.[META__CORE_SECLASS__INQUIRY_ONLY]
UNION
SELECT 'HR' AS CDDFILE,
       *
  FROM history.[META__HR_SECLASS__INQUIRY_ONLY]
UNION
SELECT 'ST' AS CDDFILE,
       *
  FROM history.[META__ST_SECLASS__INQUIRY_ONLY]
UNION
SELECT 'UT' AS CDDFILE,
       *
  FROM history.[META__UT_SECLASS__INQUIRY_ONLY]
GO

DROP VIEW [history].[META__CF_SECLASS__LIMITED_TO]
GO
CREATE VIEW [history].[META__CF_SECLASS__LIMITED_TO] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [LIMITED.TO.PROCESS.LIST]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__CF_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([LIMITED.TO.PROCESS.LIST],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__CORE_SECLASS__LIMITED_TO]
GO
CREATE VIEW [history].[META__CORE_SECLASS__LIMITED_TO] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [LIMITED.TO.PROCESS.LIST]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__CORE_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([LIMITED.TO.PROCESS.LIST],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__HR_SECLASS__LIMITED_TO]
GO
CREATE VIEW [history].[META__HR_SECLASS__LIMITED_TO] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [LIMITED.TO.PROCESS.LIST]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__HR_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([LIMITED.TO.PROCESS.LIST],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__ST_SECLASS__LIMITED_TO]
GO
CREATE VIEW [history].[META__ST_SECLASS__LIMITED_TO] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [LIMITED.TO.PROCESS.LIST]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__ST_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([LIMITED.TO.PROCESS.LIST],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__UT_SECLASS__LIMITED_TO]
GO
CREATE VIEW [history].[META__UT_SECLASS__LIMITED_TO] AS
SELECT [SYS.CLASS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(35)) AS [LIMITED.TO.PROCESS.LIST]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(500)) AS [LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[META__UT_SECLASS]
  
CROSS APPLY dw_util.DelimitedSplit8K([LIMITED.TO.PROCESS.LIST],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],', ') CA2
 WHERE COALESCE([LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber
GO

DROP VIEW [history].[META__ALL_SECLASS__LIMITED_TO]
GO
CREATE VIEW history.[META__ALL_SECLASS__LIMITED_TO] AS
SELECT 'CF' AS CDDFILE,
       *       
  FROM history.[META__CF_SECLASS__LIMITED_TO]
UNION
SELECT 'CORE' AS CDDFILE,
       *
  FROM history.[META__CORE_SECLASS__LIMITED_TO]
UNION
SELECT 'HR' AS CDDFILE,
       *
  FROM history.[META__HR_SECLASS__LIMITED_TO]
UNION
SELECT 'ST' AS CDDFILE,
       *
  FROM history.[META__ST_SECLASS__LIMITED_TO]
UNION
SELECT 'UT' AS CDDFILE,
       *
  FROM history.[META__UT_SECLASS__LIMITED_TO]
GO

DROP VIEW [history].[META__ALL_SECLASS__ALL_CLASSES]
GO
CREATE VIEW history.[META__ALL_SECLASS__ALL_CLASSES] AS
SELECT 'Privileged' AS PERMISSION_TYPE
     , [SYS.CLASS.ID]
     , [DENY.ACCESS.EXCEPT.TO.CLASS] AS MNEMONIC
     , [DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION] AS PROCESS_DESCRIPTION
     , ItemNumber
     , EffectiveDatetime    
  FROM history.[META__ALL_SECLASS__DENY_ACCESS]
UNION
SELECT 'Inquiry Only' AS PERMISSION_TYPE
     , [SYS.CLASS.ID]
     , [INQUIRY.ONLY.PROCESS.LIST] AS MNEMONIC
     , [INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION] AS PROCESS_DESCRIPTION
     , ItemNumber
     , EffectiveDatetime    
  FROM history.[META__ALL_SECLASS__INQUIRY_ONLY]
UNION
SELECT 'Do Only These' AS PERMISSION_TYPE
     , [SYS.CLASS.ID]
     , [LIMITED.TO.PROCESS.LIST] AS MNEMONIC
     , [LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION] AS PROCESS_DESCRIPTION
     , ItemNumber
     , EffectiveDatetime    
  FROM history.[META__ALL_SECLASS__LIMITED_TO]
GO
