/* Add Columns */
ALTER TABLE ${TableSchema}.${TableName}
    ALTER COLUMN [${TableKey}] ${TableKey_Type} NOT NULL;
COMMIT
