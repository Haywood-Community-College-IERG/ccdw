USE [IERG]
GO
/****** Object:  View [history].[INSTITUTIONS_Current]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[INSTITUTIONS_Current] AS
  SELECT [INSTITUTIONS.ID], [INST.SORT.NAME], [INST.TYPE], [CORP.FICE], [INST.CEEB], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[INSTITUTIONS]
  WHERE CurrentFlag = 'Y'
GO
