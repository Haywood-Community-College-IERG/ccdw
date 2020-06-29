WITH Views AS (
    SELECT v.TABLE_CATALOG, v.TABLE_SCHEMA, v.TABLE_NAME
      FROM INFORMATION_SCHEMA.VIEWS v
     WHERE TABLE_SCHEMA = 'history'
), Tables AS (
    SELECT t.TABLE_CATALOG, t.TABLE_SCHEMA, t.TABLE_NAME
      FROM INFORMATION_SCHEMA.TABLES t
     WHERE TABLE_SCHEMA = 'history'
)
SELECT 'CREATE VIEW [' + v.TABLE_SCHEMA + '].[' + v.TABLE_NAME + ']' + CHAR(13) + CHAR(10) +
           'AS SELECT * FROM [' + v.TABLE_CATALOG + '].[' + v.TABLE_SCHEMA + '].[' + v.TABLE_NAME + ']' + CHAR(13) + CHAR(10) +
        'GO'
  FROM Views v

UNION

SELECT 'CREATE VIEW [' + t.TABLE_SCHEMA + '].[' + t.TABLE_NAME + ']' + CHAR(13) + CHAR(10) +
           'AS SELECT * FROM [' + t.TABLE_CATALOG + '].[' + t.TABLE_SCHEMA + '].[' + t.TABLE_NAME + ']' + CHAR(13) + CHAR(10) +
        'GO'
  FROM Tables t

