/* TYPE 2 MERGES */
INSERT INTO ${TableSchema_DEST}.${TableName}
    (
        ${TableColumns},
        [Audit_Key],
        [EffectiveDatetime],
        [ExpirationDatetime],
        [CurrentFlag]
    )
    SELECT 
        ${TableColumns},
        [Audit_Key],
        [EffectiveDatetime],
        [ExpirationDatetime],
        [CurrentFlag] 
    FROM
    (MERGE INTO ${TableSchema_DEST}.${TableName} DEST
        USING (SELECT DISTINCT * FROM ${TableSchema_SRC}.${TableName}) SRC ON (
             /*DEST.[TableKey] = SRC.[TableKey]*/
            ${TableKeys_CMP}
        )

        /* No record exists in the destination table so insert new records */
        WHEN NOT MATCHED BY TARGET THEN
            INSERT 
            (
                    ${TableColumns},
                    Audit_Key,
                    EffectiveDatetime,
                    ExpirationDatetime, 
                    CurrentFlag
            )
            VALUES 
            (  
                    ${TableColumns_SRC},
                    CAST(${AuditKey} AS INTEGER),
                    CAST(SRC.DataDatetime AS datetime2),
                    NULL, 
                    'Y'
            )

        /* No record sxists in the source table so mark record expired */
        /* We are assuming no records will ever be deleted! */
        /*
        WHEN NOT MATCHED BY SOURCE 
        AND DEST.ExpirationDatetime IS NULL
        AND DEST.CurrentFlag = 'Y' 
        THEN
            UPDATE SET DEST.CurrentFlag = 'N', 
                        DEST.ExpirationDatetime = COALESCE(DEST.ExpirationDatetime, "${TableDefaultDate}")
        */

        /* This marks the older record to be outdated for SCD Type 2 */
        WHEN MATCHED 
        AND DEST.ExpirationDatetime IS NULL
        AND DEST.CurrentFlag = 'Y' 
        AND EXISTS
            (SELECT ${TableColumns2_SRC} 
             EXCEPT
             SELECT ${TableColumns2_DEST}
            )
            THEN UPDATE SET 
                DEST.CurrentFlag = 'N', 
                DEST.ExpirationDatetime = CAST(SRC.DataDatetime AS datetime2)

        OUTPUT $$ACTION Action_Taken,
            ${TableColumns_SRC},
            CAST(${AuditKey} AS INTEGER) AS Audit_Key,
            CAST(SRC.DataDatetime AS datetime2) AS EffectiveDatetime, 
            NULL AS ExpirationDatetime, 
            'Y' AS CurrentFlag
        ) AS MERGE_OUT
    WHERE MERGE_OUT.Action_Taken = 'UPDATE'

COMMIT
