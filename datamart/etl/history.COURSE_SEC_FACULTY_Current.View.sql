USE [IERG]
GO
/****** Object:  View [history].[COURSE_SEC_FACULTY_Current]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[COURSE_SEC_FACULTY_Current] AS
  SELECT [COURSE.SEC.FACULTY.ID], [CSF.FACULTY], [XCSF.FACULTY.FTE], [CSF.FACULTY.LOAD], [CSF.FACULTY.PCT], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[COURSE_SEC_FACULTY]
  WHERE CurrentFlag = 'Y'
GO
