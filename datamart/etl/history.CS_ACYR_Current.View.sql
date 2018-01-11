USE [IERG]
GO
/****** Object:  View [history].[CS_ACYR_Current]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[CS_ACYR_Current] AS
  SELECT [CS.STUDENT.ID], [CS.YEAR], [CS.AWARD], [CS.FC], [CS.VERIF.STATUS], [CS.VERIF.DT], [CS.VERIF.FLAGS], [CS.HAS.ISIR], [CS.ACYR.ADD.DATE], [CS.ACYR.ADD.OPERATOR], [CS.ACYR.CHANGE.DATE], [CS.ACYR.CHANGE.OPERATOR], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[CS_ACYR]
  WHERE CurrentFlag = 'Y'
GO
