/* -------------------------------------------------------- *
 *
 * Object Name: history.STUDENTS__STU_TYPES
 * Object Type: View
 * Creation Date: 2019-07-31
 *
 * Change log: 
 *     20190731 DMO New, based off of existing version
 *                     created by the CCDW import program.
 *     20200608 DMO Changed dbo.DelimitedSplit8k to dw_util.DelimitedSplit8k.
 *
 * -------------------------------------------------------- */
--/*
IF OBJECT_ID('history.STUDENTS__STU_TYPES', 'V') IS NOT NULL
    DROP VIEW history.STUDENTS__STU_TYPES
GO

CREATE VIEW history.STUDENTS__STU_TYPES AS 
-- */
SELECT [STUDENTS.ID]
     , LTRIM(RTRIM(CA1.Item)) AS [STU.TYPES]
     , CAST(LTRIM(RTRIM(CA2.Item)) AS DATE) AS [STU.TYPE.DATES]
     -- Fix blank and NULL dates to default to far in the future
     , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA3.Item)),'') = ''
                      THEN '9999-12-31'
                 ELSE LTRIM(RTRIM(CA3.Item)) END AS DATE) AS [STU.TYPE.END.DATES]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[STUDENTS] 
 CROSS APPLY dw_util.DelimitedSplit8K([STU.TYPES], ', ') CA1 
 CROSS APPLY dw_util.DelimitedSplit8K([STU.TYPE.DATES], ', ') CA2 
 CROSS APPLY dw_util.DelimitedSplit8K([STU.TYPE.END.DATES], ', ') CA3
 WHERE COALESCE ([STU.TYPES], '') != '' 
   AND CA1.ItemNumber = CA2.ItemNumber 
   AND CA1.ItemNumber = CA3.ItemNumber
;
GO

/* *

-- This code is needed to fix some records that are incorrect in the original database. 
-- Some records are missing the commas between the end dates. This messes up the date 
-- calculations in this view.

-- This code requires the function RegEx_IsMatch4k from SQL# (http://sqlsharp.com), version 4.2. 
-- It is part of the free download. The zip file can be found in ccdw/sql.

UPDATE history.STUDENTS
SET [STU.TYPE.END.DATES] = REPLACE([STU.TYPE.END.DATES],' ',', ')
      ,[STU.CLASS]
      ,[STU.SSN]
      ,[EffectiveDatetime]
      ,[ExpirationDatetime]
      ,[CurrentFlag]
    WHERE Sql#.RegEx_IsMatch4k( [STU.TYPE.END.DATES], '^(?:\s\d{4}-\d{2}-\d{2})+$', 1, '') > 0

-- */