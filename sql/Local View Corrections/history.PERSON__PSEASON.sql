/* -------------------------------------------------------- *
 *
 * Object Name: history.PERSON__PSEASON
 * Object Type: View
 * Creation Date: 2021-07-19
 *
 * Change log: 
 *     20210719 DMO New, based off of existing version
 *
 * -------------------------------------------------------- */
--/*
IF OBJECT_ID('history.PERSON__PSEASON', 'V') IS NOT NULL
    DROP VIEW history.PERSON__PSEASON
GO

CREATE VIEW history.PERSON__PSEASON AS 
-- */
SELECT [ID]
     , CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(20)) AS [ADDR.TYPE]
     , CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(15)) AS [PERSON.ADDRESSES]
     , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA3.Item)),'') = ''
                      THEN '1900-01-01'
                 ELSE LTRIM(RTRIM(CA3.Item)) END AS DATE) AS [ADDR.EFFECTIVE.START]
     , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA4.Item)),'') = ''
                      THEN '9999-12-31'
                 ELSE LTRIM(RTRIM(CA4.Item)) END AS DATE) AS [ADDR.EFFECTIVE.END]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[PERSON] 
 CROSS APPLY dw_util.DelimitedSplit8K([ADDR.TYPE], ', ') CA1 
 CROSS APPLY dw_util.DelimitedSplit8K([PERSON.ADDRESSES], ', ') CA2 
 CROSS APPLY dw_util.DelimitedSplit8K([ADDR.EFFECTIVE.START], ', ') CA3
 CROSS APPLY dw_util.DelimitedSplit8K([ADDR.EFFECTIVE.END], ', ') CA4
 WHERE COALESCE ([ADDR.TYPE], '') != '' 
   AND CA1.ItemNumber = CA2.ItemNumber 
   AND CA1.ItemNumber = CA3.ItemNumber 
   AND CA1.ItemNumber = CA4.ItemNumber 
;
GO
