CREATE TABLE [dw].[DimPrograms]
(
	[Programs_Key] INT NOT NULL  IDENTITY, 
    [Terms_Key] INT NULL, 
    [Program Code] NVARCHAR(10) NULL, 
    [Program Name] NVARCHAR(255) NULL, 
    [Credential Code] NVARCHAR(10) NULL, 
    [Credential Type] NVARCHAR(50) NULL, 
    [Major Code] NVARCHAR(10) NULL, 
    [Major Name] NVARCHAR(100) NULL, 
    [Major CIP] NCHAR(7) NULL, 
    [Academic Level] NVARCHAR(50) NULL, 
    [Degree Code] NVARCHAR(10) NULL, 
    [Initial Catalog] INT NULL, 
    [Program Start Date] DATE NULL, 
    [Program End Date] DATE NULL, 
    CONSTRAINT [PK_DimPrograms] PRIMARY KEY ([Programs_Key]), 
    CONSTRAINT [FK_DimPrograms_DimTerms] FOREIGN KEY ([Terms_Key]) REFERENCES [dw].[DimTerms]([Terms_Key])
)
