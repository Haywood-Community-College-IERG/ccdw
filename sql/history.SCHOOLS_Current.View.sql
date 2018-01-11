USE [IERG]
GO
/****** Object:  View [history].[SCHOOLS_Current]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[SCHOOLS_Current] AS
  SELECT [SCHOOLS.ID], [SCHOOLS.DESC], [SCHOOLS.INSTITUTIONS.ID], [SCHOOLS.DIVISIONS], [SCHOOLS.DEPTS], [SCHOOLS.ADD.OPERATOR], [SCHOOLS.ADD.DATE], [SCHOOLS.CHANGE.OPERATOR], [SCHOOLS.CHANGE.DATE], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[SCHOOLS]
  WHERE CurrentFlag = 'Y'
GO
