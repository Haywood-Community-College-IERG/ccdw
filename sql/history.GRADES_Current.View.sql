USE [IERG]
GO
/****** Object:  View [history].[GRADES_Current]    Script Date: 1/11/2018 9:56:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[GRADES_Current] AS
  SELECT [GRADES.ID], [GRD.GRADE], [GRD.LEGEND], [GRD.GRADE.SCHEME], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[GRADES]
  WHERE CurrentFlag = 'Y'
GO
