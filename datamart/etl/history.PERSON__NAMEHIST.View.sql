USE [IERG]
GO
/****** Object:  View [history].[PERSON__NAMEHIST]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[PERSON__NAMEHIST] AS
SELECT [ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(25)) AS [NAME.HISTORY.LAST.NAME]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[PERSON]
  
 CROSS APPLY dbo.DelimitedSplit8K([NAME.HISTORY.LAST.NAME],', ') CA1
 WHERE COALESCE([NAME.HISTORY.LAST.NAME],'') != ''
       
GO
