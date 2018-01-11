USE [IERG]
GO
/****** Object:  View [history].[STATES_Current]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[STATES_Current] AS
  SELECT [ID], [ST.DESC], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[STATES]
  WHERE CurrentFlag = 'Y'
GO
