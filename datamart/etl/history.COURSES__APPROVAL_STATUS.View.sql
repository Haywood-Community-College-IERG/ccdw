USE [IERG]
GO
/****** Object:  View [history].[COURSES__APPROVAL_STATUS]    Script Date: 1/11/2018 10:12:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[COURSES__APPROVAL_STATUS] AS
SELECT [COURSES.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(30)) AS [CRS.STATUS]
, CAST(LTRIM(RTRIM(CA2.Item)) AS DATE) AS [CRS.STATUS.DATE]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[COURSES]
  
 CROSS APPLY dbo.DelimitedSplit8K([CRS.STATUS],', ') CA1
 CROSS APPLY dbo.DelimitedSplit8K([CRS.STATUS.DATE],', ') CA2
 WHERE COALESCE([CRS.STATUS],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber

GO
