USE [IERG]
GO
/****** Object:  View [history].[PERSON_ST_Current]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[PERSON_ST_Current] AS
  SELECT [PERSON.ST.ID], [PST.EDUC.GOALS], [PST.ADVISOR.NAME], [EffectiveDatetime], [ExpirationDatetime], [CurrentFlag] 
  FROM [history].[PERSON_ST]
  WHERE CurrentFlag = 'Y'
GO
