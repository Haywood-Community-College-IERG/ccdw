USE [IERG]
GO
/****** Object:  View [history].[MAJORS_Current]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[MAJORS_Current] AS
  SELECT [MAJORS.ID], [MAJ.ACTIVE.FLAG], [MAJ.CIP], [MAJ.DESC], [MAJ.DIVISION], [MAJORS.ADDDATE], [MAJORS.ADDOPR], [MAJORS.CHGDATE], [MAJORS.CHGOPR], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[MAJORS]
  WHERE CurrentFlag = 'Y'
GO
