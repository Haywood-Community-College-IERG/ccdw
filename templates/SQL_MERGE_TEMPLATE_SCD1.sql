MERGE INTO ${TableSchema_DEST}.${TableName} DEST
USING ${TableSchema_SRC}.${TableName} SRC ON (
    -- DEST.[TableKey] = SRC.[TableKey]
    ${TableKeys_CMP}
)
WHEN MATCHED 
AND EXISTS
    (SELECT ${TableColumns1_SRC} 
     EXCEPT
     SELECT ${TableColumns1_DEST}
    )
THEN 
    -- DEST.COL = SRC.COL
    UPDATE SET ${TableColumns1_UPDATE}
