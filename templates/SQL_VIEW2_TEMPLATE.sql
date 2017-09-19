CREATE VIEW [${viewSchema}].[${TableName}__${viewName2}] AS
SELECT ${primaryKeys}
       ${str1}
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [${viewSchema}].[${TableName}]
  ${str2}
 WHERE 
   ${str3}
   COALESCE([${associationKeys}],'') != ''