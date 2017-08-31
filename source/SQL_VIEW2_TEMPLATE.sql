CREATE VIEW [${viewSchema}].[${TableName}__${viewName2}] AS
SELECT ${primaryKeys}
     ${str1}
	   , EffectiveDatetime
  FROM [${viewSchema}].[${TableName}]
  ${str2}
 WHERE 
   ${str3}
   AND COALESCE([${associationKeys}],'') != ''