USE [IERG]
GO
/****** Object:  View [history].[HRPER__STATUS_DATES]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[HRPER__STATUS_DATES] AS
SELECT [HRPER.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS DATE) AS [HRP.PERSTAT.START.DATE]
, CAST(LTRIM(RTRIM(CA2.Item)) AS DATE) AS [HRP.PERSTAT.END.DATE]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[HRPER]
  
 CROSS APPLY dbo.DelimitedSplit8K([HRP.PERSTAT.START.DATE],', ') CA1
 CROSS APPLY dbo.DelimitedSplit8K([HRP.PERSTAT.END.DATE],', ') CA2
 WHERE COALESCE([HRP.PERSTAT.START.DATE],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber

GO
