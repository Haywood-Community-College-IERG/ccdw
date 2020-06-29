USE CCDW_HIST 
GO

DECLARE @ETL_Source VARCHAR(20) = 'Setup SQL';
DECLARE @ETL_Version VARCHAR(10) = '1.0.0';

-- DROP TABLE dw_dim.Audit

CREATE TABLE dw_dim.Audit
(
    Audit_Key INT IDENTITY(0,1) NOT NULL,
    Parent_Audit_Key INT NOT NULL DEFAULT(0),

    Table_Name VARCHAR(100) NOT NULL DEFAULT('Unknown'),
    Data_Source VARCHAR(500) NOT NULL DEFAULT('Unknown'),
    
    Records_Modified INT NOT NULL DEFAULT(0),

    Load_Error_Indicator CHAR(1) NOT NULL DEFAULT('N'),

    Load_Start_Datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Load_End_Datetime DATETIME NULL,

    ETL_Source VARCHAR(50) NOT NULL DEFAULT('Unknown'),
    ETL_Version VARCHAR(10) NOT NULL DEFAULT('Unknown')

    CONSTRAINT [PK_dw_dim.Audit] 
        PRIMARY KEY CLUSTERED ( Audit_Key )
);

ALTER TABLE dw_dim.Audit WITH CHECK ADD CONSTRAINT [FK_Audit_Parent_AuditKey] FOREIGN KEY( Parent_Audit_Key )
REFERENCES dw_dim.Audit ( Audit_Key )

ALTER TABLE dw_dim.Audit CHECK CONSTRAINT FK_Audit_Parent_AuditKey

INSERT INTO dw_dim.Audit (Table_Name, Data_Source, ETL_Source, ETL_Version)
    VALUES ( 'Undefined', 'Undefined', @ETL_Source, @ETL_Version )

UPDATE dw_dim.Audit
    SET Load_End_Datetime = Load_Start_Datetime
;