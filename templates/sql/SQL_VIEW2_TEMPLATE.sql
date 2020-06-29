CREATE VIEW [${ViewSchema}].[${ViewName}] AS
SELECT ${primaryKeys}
       ${CastStr}
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [${ViewSchema}].[${TableName}]
  ${CrossApplyStr}
 WHERE COALESCE([${associationKeys}],'') != ''
       ${WhereAndStr}