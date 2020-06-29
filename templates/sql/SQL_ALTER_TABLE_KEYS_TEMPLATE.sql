ALTER TABLE ${TableSchema_DEST}.${TableName}
ADD CONSTRAINT ${pkName} PRIMARY KEY (${primaryKeys}, [EffectiveDatetime]);