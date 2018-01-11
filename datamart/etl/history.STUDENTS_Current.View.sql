USE [IERG]
GO
/****** Object:  View [history].[STUDENTS_Current]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[STUDENTS_Current] AS
  SELECT [STUDENTS.ID], [STU.RESIDENCY.STATUS], [STU.RESIDENCY.STATUS.DATE], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[STUDENTS]
  WHERE CurrentFlag = 'Y'
GO
