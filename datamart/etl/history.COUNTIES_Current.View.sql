USE [IERG]
GO
/****** Object:  View [history].[COUNTIES_Current]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[COUNTIES_Current] AS
  SELECT [COUNTIES.ID], [CNTY.DESC], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[COUNTIES]
  WHERE CurrentFlag = 'Y'
GO
