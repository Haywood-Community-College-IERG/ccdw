USE [IERG]
GO
/****** Object:  View [history].[TERMS_Current]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[TERMS_Current] AS
  SELECT [TERMS.ID], [TERM.DESC], [TERM.START.DATE], [TERM.CENSUS.DATES], [TERM.END.DATE], [TERM.REPORTING.YEAR], [TERM.COMMENCEMENT.DATE], [TERM.DROP.START.DATE], [TERM.DROP.END.DATE], [TERM.REG.START.DATE], [TERM.REG.END.DATE], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[TERMS]
  WHERE CurrentFlag = 'Y'
GO
