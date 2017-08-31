CREATE VIEW [${viewSchema}].[${viewName}] AS
  SELECT ${viewColumns} 
  FROM [${viewSchema}].[${TableName}]
  WHERE CurrentFlag = 'Y'