CREATE TABLE [dw].[DimTerms]
(
	[Terms_Key] INT NOT NULL, 
    [Term Code] NVARCHAR(10) NOT NULL, 
    [Term Code Alternate] NVARCHAR(10) NULL, 
    [Term Start Date] DATE NULL, 
    [Term Census Date] DATE NULL, 
    [Term End Date] DATE NULL, 
    [Term] NVARCHAR(20) NULL, 
    [Term Description] NVARCHAR(50) NULL, 
    [Term Abbreviation] NVARCHAR(7) NULL, 
    [Term Type] NVARCHAR(50) NOT NULL, 
    [Academic Year] NCHAR(9) NULL, 
    [Year] SMALLINT NULL, 
    [Term Index] INT NULL, 
    [Term Sort Order] INT NULL, 
    [Reporting Academic Year] NCHAR(9) NULL, 
    [Reporting Year] SMALLINT NULL, 
    [Reporting Code] INT NULL, 
    [Reporting Code Alternate] INT NULL, 
    CONSTRAINT [PK_DimTerms] PRIMARY KEY ([Terms_Key]) 
)
