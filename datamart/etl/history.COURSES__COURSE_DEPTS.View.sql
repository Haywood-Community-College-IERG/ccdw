USE [IERG]
GO
/****** Object:  View [history].[COURSES__COURSE_DEPTS]    Script Date: 1/11/2018 10:12:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[COURSES__COURSE_DEPTS] AS
SELECT [COURSES.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS NUMERIC(6,2)) AS [CRS.DEPT.PCTS]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(40)) AS [CRS.DEPTS]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[COURSES]
  
 CROSS APPLY dbo.DelimitedSplit8K([CRS.DEPT.PCTS],', ') CA1
 CROSS APPLY dbo.DelimitedSplit8K([CRS.DEPTS],', ') CA2
 WHERE COALESCE([CRS.DEPTS],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber

GO
