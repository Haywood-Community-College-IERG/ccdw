USE [IERG]
GO
/****** Object:  View [history].[PERSON__PERSON_ALT]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[PERSON__PERSON_ALT] AS
SELECT [ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(30)) AS [PERSON.ALT.IDS]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[PERSON]
  
 CROSS APPLY dbo.DelimitedSplit8K([PERSON.ALT.IDS],', ') CA1
 WHERE COALESCE([PERSON.ALT.IDS],'') != ''
       
GO
