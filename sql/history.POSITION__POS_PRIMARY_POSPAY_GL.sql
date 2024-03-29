USE [IERG]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[POSITION__POS_PRIMARY_POSPAY_GL] AS
SELECT [POSITION.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(30)) AS [POS.PRIMARY.POSPAY.GL]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[POSITION]
  
 CROSS APPLY dbo.DelimitedSplit8K([POS.PRIMARY.POSPAY.GL],', ') CA1
 WHERE COALESCE([POS.PRIMARY.POSPAY.GL],'') != ''
       
GO
