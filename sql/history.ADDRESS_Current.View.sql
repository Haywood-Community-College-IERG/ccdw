USE [IERG]
GO
/****** Object:  View [history].[ADDRESS_Current]    Script Date: 1/11/2018 9:56:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[ADDRESS_Current] AS
  SELECT [ADDRESS.ID], [RESIDENTS], [ADDRESS.LINES], [CITY], [STATE], [ZIP], [COUNTY], [CNTY.DESC], [COUNTRY], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[ADDRESS]
  WHERE CurrentFlag = 'Y'
GO
