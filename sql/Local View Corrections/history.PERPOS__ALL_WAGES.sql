/* -------------------------------------------------------- *
 *
 * Object Name: history.PERPOS__ALL_WAGES
 * Object Type: View
 * Creation Date: 2020-11-02
 *
 * Change log: 
 *     20201102 DMO New.
 *
 * -------------------------------------------------------- */
--/*
IF OBJECT_ID('history.PERPOS__ALL_WAGES', 'V') IS NOT NULL
    DROP VIEW history.PERPOS__ALL_WAGES
GO

CREATE VIEW history.PERPOS__ALL_WAGES AS 
-- */
SELECT [PERPOS.ID]
     , [POSITION.ID]
     , CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(10)) AS [ALL.POSITION.WAGES]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[PERPOS] 
 CROSS APPLY dw_util.DelimitedSplit8K([ALL.POSITION.WAGES], ', ') CA1 
 WHERE COALESCE ([ALL.POSITION.WAGES], '') != '' 
;
GO
