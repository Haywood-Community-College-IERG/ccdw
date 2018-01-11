USE [IERG]
GO
/****** Object:  View [history].[XLE_STUDENTS__XLE_AHS_DCRS_ATT]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[XLE_STUDENTS__XLE_AHS_DCRS_ATT] AS
SELECT [XLE.STUDENTS.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS DATE) AS [XLE.AHS.1ST.ATTDATE]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[XLE_STUDENTS]
  
 CROSS APPLY dbo.DelimitedSplit8K([XLE.AHS.1ST.ATTDATE],', ') CA1
 WHERE COALESCE([XLE.AHS.1ST.ATTDATE],'') != ''
       
GO
