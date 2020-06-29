CREATE VIEW [${ViewSchema}].[${ViewName}] AS
  SELECT ${ViewColumns} 
  FROM [${TableSchema_DEST}].[${TableName}]
  WHERE CurrentFlag = 'Y'