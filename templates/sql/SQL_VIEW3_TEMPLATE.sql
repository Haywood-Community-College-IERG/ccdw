CREATE VIEW [${ViewSchema}].[${ViewName}] AS
  SELECT *
  FROM [${TableSchema}].[${TableName}]
 WHERE CurrentFlag = 'Y'