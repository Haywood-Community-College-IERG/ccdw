USE [IERG]
GO
/****** Object:  View [history].[INSTITUTIONS_ATTEND_Current]    Script Date: 1/11/2018 9:56:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[INSTITUTIONS_ATTEND_Current] AS
  SELECT [INSTA.INSTITUTIONS.ID], [INSTA.PERSON.ID], [INSTA.START.DATES], [INSTA.END.DATES], [INSTA.ACAD.CREDENTIALS], [X.INSTA.INSTITUTION], [INSTA.INST.TYPE], [X.INSTA.842.ADR.STATE], [X.INSTA.842.PREF.CITY], [INSTA.GRAD.TYPE], [INSTA.TRANSCRIPT.STATUS], [INSTA.TRANSCRIPT.DATE], [INSTA.TRANSCRIPT.TYPE], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[INSTITUTIONS_ATTEND]
  WHERE CurrentFlag = 'Y'
GO
