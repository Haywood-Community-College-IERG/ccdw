USE [IERG]
GO
/****** Object:  View [history].[PERSON__VETERAN_ASSOC]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[PERSON__VETERAN_ASSOC] AS
SELECT [ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(20)) AS [VETERAN.TYPE]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[PERSON]
  
 CROSS APPLY dbo.DelimitedSplit8K([VETERAN.TYPE],', ') CA1
 WHERE COALESCE([VETERAN.TYPE],'') != ''
       
GO
