USE [IERG]
GO
/****** Object:  View [history].[STUDENT_PROGRAMS_Current]    Script Date: 1/11/2018 9:56:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[STUDENT_PROGRAMS_Current] AS
  SELECT [STPR.STUDENT], [STPR.ACAD.PROGRAM], [STPR.ADMIT.STATUS], [STPR.CATALOG], [STPR.DEPT], [STPR.START.DATE], [STPR.END.DATE], [STPR.EVAL.MAJOR.GPA.MV], [STPR.STUDENT.ED.PLAN], [STPR.USER1], [STPR.STATUS], [STPR.STATUS.DATE], [STPR.STATUS.CHGOPR], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[STUDENT_PROGRAMS]
  WHERE CurrentFlag = 'Y'
GO
