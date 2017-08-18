/* TYPE 2 MERGES */
INSERT INTO ${TableSchema}.${TableName}_History
    SELECT 
        ${TableColumns},
        [EffectiveDate],
        [ExpirationDate],
        [CurrentFlag] 
    FROM
    (MERGE INTO ${TableSchema}.${TableName}_History DEST
        USING ${TableSchema}.${TableName} SRC ON (
             /*DEST.[TableKey] = SRC.[TableKey]*/
            ${TableKeys_CMP}
        )

        /* No record exists in the destination table so insert new records */
        WHEN NOT MATCHED BY TARGET THEN
            INSERT 
            (
                    ${TableColumns},
                    EffectiveDate,
                    ExpirationDate, 
                    CurrentFlag
            )
            VALUES 
            (  
                    ${TableColumns_SRC},
                    GETDATE(),
                    NULL, 
                    'Y'
            )

        /* No record sxists in the source table so mark record expired */
        WHEN NOT MATCHED BY SOURCE 
        AND DEST.ExpirationDate IS NULL
        AND DEST.CurrentFlag = 'Y' 
        THEN
            UPDATE SET DEST.CurrentFlag = 'N', 
                        DEST.ExpirationDate = COALESCE(DEST.ExpirationDate,GETDATE())

        /* This marks the older record to be outdated for SCD Type 2 */
        WHEN MATCHED 
        AND DEST.ExpirationDate IS NULL
        AND DEST.CurrentFlag = 'Y' 
        AND EXISTS
            (SELECT ${TableColumns2_SRC} 
             EXCEPT
             SELECT ${TableColumns2_DEST}
            )
            THEN UPDATE SET 
                DEST.CurrentFlag = 'N', 
                DEST.ExpirationDate = COALESCE(DEST.ExpirationDate,GETDATE())

        OUTPUT $$ACTION Action_Taken,
            ${TableColumns_SRC},
            GETDATE() AS EffectiveDate, 
            NULL AS ExpirationDate, 
            'Y' AS CurrentFlag
        ) AS MERGE_OUT
    WHERE MERGE_OUT.Action_Taken = 'UPDATE'

COMMIT
