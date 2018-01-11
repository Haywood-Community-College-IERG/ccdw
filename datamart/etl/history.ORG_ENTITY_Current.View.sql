USE [IERG]
GO
/****** Object:  View [history].[ORG_ENTITY_Current]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[ORG_ENTITY_Current] AS
  SELECT [ORG.ENTITY.ID], [OEE.USERNAME], [OE.PREFIX], [OE.FIRST.NAME], [OE.MIDDLE.NAME], [OE.LAST.NAME], [OE.SUFFIX], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[ORG_ENTITY]
  WHERE CurrentFlag = 'Y'
GO
