SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP VIEW [history].[ELF_TRANSLATE_TABLES__ELFTBL]
GO
CREATE VIEW [history].[ELF_TRANSLATE_TABLES__ELFTBL] AS
SELECT [ELF.TRANSLATE.TABLES.ID]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(20)) AS [ELFT.NEW.CODES]
, CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(20)) AS [ELFT.ORIG.CODES]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[ELF_TRANSLATE_TABLES]
  
CROSS APPLY dw_util.DelimitedSplit8K([ELFT.NEW.CODES],', ') CA1
CROSS APPLY dw_util.DelimitedSplit8K([ELFT.ORIG.CODES],', ') CA2
 WHERE COALESCE([ELFT.NEW.CODES],'') != ''
       AND CA1.ItemNumber=CA2.ItemNumber

GO
