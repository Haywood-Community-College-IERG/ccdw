USE [IERG]
GO
/****** Object:  View [history].[COUNTRIES_Current]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[COUNTRIES_Current] AS
  SELECT [COUNTRIES.ID], [CTRY.DESC], [CTRY.ISO.CODE], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[COUNTRIES]
  WHERE CurrentFlag = 'Y'
GO
