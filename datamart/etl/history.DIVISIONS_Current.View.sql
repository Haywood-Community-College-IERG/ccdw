USE [IERG]
GO
/****** Object:  View [history].[DIVISIONS_Current]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[DIVISIONS_Current] AS
  SELECT [DIVISIONS.ID], [DIV.DESC], [DIV.INSTITUTIONS.ID], [DIV.TYPE], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[DIVISIONS]
  WHERE CurrentFlag = 'Y'
GO
