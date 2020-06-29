/* Add Columns */
ALTER TABLE ${TableSchema}.${TableName}
    ADD ${updateColumns}; 

COMMIT
