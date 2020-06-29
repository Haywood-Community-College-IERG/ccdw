/* -------------------------------------------------------- *
 *
 * Object Name: history.STUDENTS__STU_TERMS
 * Object Type: View
 * Creation Date: 2020-02-13
 *
 * Change log: 
 *     20200213 DMO New, no association defined for this field
 *
 * -------------------------------------------------------- */
--/*
IF OBJECT_ID('history.STUDENTS__STU_TERMS', 'V') IS NOT NULL
    DROP VIEW history.STUDENTS__STU_TERMS
GO

CREATE VIEW history.STUDENTS__STU_TERMS AS 
-- */
SELECT [STUDENTS.ID]
     , LTRIM(RTRIM(CA1.Item)) AS [STU.TERMS]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[STUDENTS]
 CROSS APPLY dbo.DelimitedSplit8K([STU.TERMS], ', ') CA1 
 WHERE COALESCE ([STU.TERMS], '') != '' 
;
GO
