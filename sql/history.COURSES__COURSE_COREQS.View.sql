USE [IERG]
GO
/****** Object:  View [history].[COURSES__COURSE_COREQS]    Script Date: 1/11/2018 9:56:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[COURSES__COURSE_COREQS] AS
SELECT [COURSES.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(3)) AS [CRS.COREQ.COURSES.REQD.FLAG]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(15)) AS [CRS.COREQ.COURSES]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[COURSES]
  
 CROSS APPLY dbo.DelimitedSplit8K([CRS.COREQ.COURSES.REQD.FLAG],', ') CA1
 CROSS APPLY dbo.DelimitedSplit8K([CRS.COREQ.COURSES],', ') CA2
 WHERE COALESCE([CRS.COREQ.COURSES],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber

GO
