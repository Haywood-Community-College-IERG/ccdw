SELECT DISTINCT
       COLUMN_NAME
     , DATA_TYPE
     , CHARACTER_MAXIMUM_LENGTH
     , NUMERIC_PRECISION
     , NUMERIC_PRECISION_RADIX
     , NUMERIC_SCALE
     , DATETIME_PRECISION
     , CASE WHEN DATA_TYPE='numeric' THEN 
                 'NUMERIC(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')'
            WHEN DATA_TYPE='varchar' THEN
                 'VARCHAR(' + CASE WHEN CHARACTER_MAXIMUM_LENGTH < 0 THEN 'MAX' 
                                   ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) END + ')' 
            ELSE UPPER(DATA_TYPE) END AS DATA_TYPE_TEXT
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = ${TableSchema}
   AND TABLE_NAME = ${TableName}