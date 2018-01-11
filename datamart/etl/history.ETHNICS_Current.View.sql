USE [IERG]
GO
/****** Object:  View [history].[ETHNICS_Current]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[ETHNICS_Current] AS
  SELECT [ETHNICS.ID], [ETH.DESC], [ETHNICS.ADD.DATE], [ETHNICS.ADD.OPERATOR], [ETHNICS.CHANGE.DATE], [ETHNICS.CHANGE.OPERATOR], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[ETHNICS]
  WHERE CurrentFlag = 'Y'
GO
