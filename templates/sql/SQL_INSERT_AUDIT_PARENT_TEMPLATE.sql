INSERT INTO [${Audit_Schema}].[${Audit_Table_Name}] (Table_Name, ETL_Source, ETL_Version)
    OUTPUT INSERTED.Audit_Key
    VALUES ('${Table_Name}','${ETL_Source}','${ETL_Version}')