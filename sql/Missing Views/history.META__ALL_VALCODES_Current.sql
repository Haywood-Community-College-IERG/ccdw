IF OBJECT_ID('history.[META__ALL_VALCODES_Current]', 'V') IS NOT NULL
    DROP VIEW history.[META__ALL_VALCODES_Current]
GO

CREATE VIEW history.[META__ALL_VALCODES_Current] AS
SELECT 'CF' AS CDDFILE,
       *       
  FROM history.[META__CF_VALCODES_Current]
UNION
SELECT 'CORE' AS CDDFILE,
       *
  FROM history.[META__CORE_VALCODES_Current]
UNION
SELECT 'HR' AS CDDFILE,
       *
  FROM history.[META__HR_VALCODES_Current]
UNION
SELECT 'ST' AS CDDFILE,
       *
  FROM history.[META__ST_VALCODES_Current]
UNION
SELECT 'TOOL' AS CDDFILE,
       *
  FROM history.[META__TOOL_VALCODES_Current]
UNION
SELECT 'UT' AS CDDFILE,
       *
  FROM history.[META__UT_VALCODES_Current]

