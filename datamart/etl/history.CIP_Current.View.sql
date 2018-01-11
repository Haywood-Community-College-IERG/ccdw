USE [IERG]
GO
/****** Object:  View [history].[CIP_Current]    Script Date: 1/11/2018 10:12:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[CIP_Current] AS
  SELECT [CIP.ID], [CIP.DESC], [CIP.FORMER.CODES], [CIP.FORMER.YEAR], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[CIP]
  WHERE CurrentFlag = 'Y'
GO
