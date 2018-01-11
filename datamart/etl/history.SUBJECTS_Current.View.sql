USE [IERG]
GO
/****** Object:  View [history].[SUBJECTS_Current]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[SUBJECTS_Current] AS
  SELECT [SUBJECTS.ID], [SUBJ.DESC], [SUBJECTS.ADDDATE], [SUBJECTS.ADDOPR], [SUBJECTS.CHGDATE], [SUBJECTS.CHGOPR], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[SUBJECTS]
  WHERE CurrentFlag = 'Y'
GO
