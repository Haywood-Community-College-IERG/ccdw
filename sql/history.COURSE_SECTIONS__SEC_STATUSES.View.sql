USE [IERG]
GO
/****** Object:  View [history].[COURSE_SECTIONS__SEC_STATUSES]    Script Date: 1/11/2018 9:56:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[COURSE_SECTIONS__SEC_STATUSES] AS
SELECT [COURSE.SECTIONS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(30)) AS [SEC.STATUS]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[COURSE_SECTIONS]
  
 CROSS APPLY dbo.DelimitedSplit8K([SEC.STATUS],', ') CA1
 WHERE COALESCE([SEC.STATUS],'') != ''
       
GO
