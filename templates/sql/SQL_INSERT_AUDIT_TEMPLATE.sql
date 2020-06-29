INSERT INTO [${Audit_Schema}].[${Audit_Table_Name}] 
    (Parent_Audit_Key, Table_Name, Data_Source, ETL_Source, ETL_Version)
    OUTPUT INSERTED.Audit_Key
    VALUES (${Parent_Audit_Key}, '${Table_Name}', '${Data_Source}', '${ETL_Source}', '${ETL_Version}')