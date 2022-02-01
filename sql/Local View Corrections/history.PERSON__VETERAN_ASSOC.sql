/* -------------------------------------------------------- *
 *
 * Object Name: history.PERSON__VETERAN_ASSOC
 * Object Type: View
 * Creation Date: 2021-07-19
 *
 * Change log: 
 *     20210719 DMO New, based off of existing version
 *
 * -------------------------------------------------------- */
--/*
IF OBJECT_ID('history.PERSON__VETERAN_ASSOC', 'V') IS NOT NULL
    DROP VIEW history.PERSON__VETERAN_ASSOC
GO

CREATE VIEW history.PERSON__VETERAN_ASSOC AS 
-- */
SELECT [ID]
     , CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(20)) AS [VETERAN.TYPE]
     , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA2.Item)),'') = ''
                      THEN '1900-01-01'
                 ELSE LTRIM(RTRIM(CA2.Item)) END AS DATE) AS [VETERAN.START.DATE]
     , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA3.Item)),'') = ''
                      THEN '9999-12-31'
                 ELSE LTRIM(RTRIM(CA3.Item)) END AS DATE) AS [VETERAN.END.DATE]
     , CAST(LTRIM(RTRIM(CA4.Item)) AS VARCHAR(15)) AS [VETERAN.PROGRAM]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[PERSON] 
 CROSS APPLY dw_util.DelimitedSplit8K([VETERAN.TYPE], ', ') CA1 
 CROSS APPLY dw_util.DelimitedSplit8K([VETERAN.START.DATE], ', ') CA2 
 CROSS APPLY dw_util.DelimitedSplit8K([VETERAN.END.DATE], ', ') CA3
 CROSS APPLY dw_util.DelimitedSplit8K([VETERAN.PROGRAM], ', ') CA4
 WHERE COALESCE ([VETERAN.TYPE], '') != '' 
   AND CA1.ItemNumber = CA2.ItemNumber 
   AND CA1.ItemNumber = CA3.ItemNumber
   AND CA1.ItemNumber = CA4.ItemNumber
;
GO
