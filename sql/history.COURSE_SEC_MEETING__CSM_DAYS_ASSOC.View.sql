USE [IERG]
GO
/****** Object:  View [history].[COURSE_SEC_MEETING__CSM_DAYS_ASSOC]    Script Date: 1/11/2018 9:56:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[COURSE_SEC_MEETING__CSM_DAYS_ASSOC] AS
SELECT [COURSE.SEC.MEETING.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(15)) AS [CSM.DAYS]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[COURSE_SEC_MEETING]
  
 CROSS APPLY dbo.DelimitedSplit8K([CSM.DAYS],', ') CA1
 WHERE COALESCE([CSM.DAYS],'') != ''
       
GO
