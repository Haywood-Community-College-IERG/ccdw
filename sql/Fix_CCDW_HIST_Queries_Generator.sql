WITH Tables AS (
    SELECT REPLACE(TABLE_NAME,'_Current','') AS TABLE_NAME --,*
      FROM INFORMATION_SCHEMA.VIEWS v
      --INNER JOIN Patterns p
        --   ON v.VIEW_DEFINITION LIKE p.Pattern
     WHERE TABLE_SCHEMA = 'history'
       AND TABLE_NAME LIKE '%_Current'
       AND PATINDEX('CurrentFlag',v.VIEW_DEFINITION) = 0
       AND PATINDEX('EffectiveDatetime',v.VIEW_DEFINITION) = 0
    --   order by 1
) --, Table_Columns AS (

    SELECT Table_Columns.TABLE_SCHEMA, 
           Tables.TABLE_NAME, 
           'DROP VIEW [history].[' + Tables.TABLE_NAME + '_Current]' + CHAR(13) + CHAR(10) + 
           'GO' + CHAR(13) + CHAR(10) + 
           'CREATE VIEW [history].[' + Tables.TABLE_NAME + '_Current] AS'  + CHAR(13) + CHAR(10) +
           '    SELECT ' + CHAR(13) + CHAR(10) +
                STRING_AGG('           [' + Table_Columns.COLUMN_NAME + ']',',' + CHAR(9) + CHAR(13) + CHAR(10)) 
                    WITHIN GROUP( ORDER BY Table_Columns.ORDINAL_POSITION) +
                CHAR(13) + CHAR(10) + '      FROM [history].[' + Tables.TABLE_NAME + ']' + CHAR(13) + CHAR(10) +
                '     WHERE CurrentFlag = ''Y''' + CHAR(13) + CHAR(10) + 
           'GO' + CHAR(13) + CHAR(10) AS TABLE_COLUMNS
      FROM INFORMATION_SCHEMA.COLUMNS Table_Columns
     INNER JOIN Tables 
           ON Tables.TABLE_NAME = Table_Columns.TABLE_NAME
     WHERE TABLE_SCHEMA = 'history'
     GROUP BY Table_Columns.TABLE_SCHEMA, Tables.TABLE_NAME

--)


