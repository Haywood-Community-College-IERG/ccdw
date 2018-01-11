USE [IERG]
GO
/****** Object:  View [history].[PERSON_ST__EDUC_GOALS]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[PERSON_ST__EDUC_GOALS] AS
SELECT [PERSON.ST.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(30)) AS [PST.EDUC.GOALS]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[PERSON_ST]
  
 CROSS APPLY dbo.DelimitedSplit8K([PST.EDUC.GOALS],', ') CA1
 WHERE COALESCE([PST.EDUC.GOALS],'') != ''
       
GO
