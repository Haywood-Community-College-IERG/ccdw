/* -------------------------------------------------------- *
 *
 * Object Name: history.STUDENTS__TERMS
 * Object Type: View
 * Creation Date: 2020-10-15
 *
 * Change log: 
 *     20201015 DMO New
 *
 * -------------------------------------------------------- */
--/*
IF OBJECT_ID('history.STUDENTS__TERMS', 'V') IS NOT NULL
    DROP VIEW history.STUDENTS__TERMS
GO

CREATE VIEW history.STUDENTS__TERMS AS 
-- */
SELECT [STUDENTS.ID]
     , LTRIM(RTRIM(CA1.Item)) AS [STU.TERMS]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[STUDENTS] 
 CROSS APPLY dw_util.DelimitedSplit8K([STU.TERMS], ', ') CA1 
 WHERE COALESCE ([STU.TERMS], '') != '' 
;
GO