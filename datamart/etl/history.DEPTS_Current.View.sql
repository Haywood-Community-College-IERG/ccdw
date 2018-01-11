USE [IERG]
GO
/****** Object:  View [history].[DEPTS_Current]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[DEPTS_Current] AS
  SELECT [DEPTS.ID], [DEPTS.INSTITUTIONS.ID], [DEPTS.TYPE], [DEPTS.SCHOOL], [DEPTS.CIP], [DEPTS.DESC], [DEPTS.DESC.LKUP], [DEPTS.TERMINAL.DEGREE], [DEPTS.HEAD.ID], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[DEPTS]
  WHERE CurrentFlag = 'Y'
GO
