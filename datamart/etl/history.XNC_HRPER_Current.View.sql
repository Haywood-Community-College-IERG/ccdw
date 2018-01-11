USE [IERG]
GO
/****** Object:  View [history].[XNC_HRPER_Current]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[XNC_HRPER_Current] AS
  SELECT [XNC.HRPER.ID], [XHRP.ACAD.LEVEL], [ACAD.LEVEL.DESC], [XHRP.AOI], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[XNC_HRPER]
  WHERE CurrentFlag = 'Y'
GO
