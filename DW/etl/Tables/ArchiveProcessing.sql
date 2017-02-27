CREATE TABLE [etl].[ArchiveProcessing] (
    [Folder Path]     NVARCHAR (255) NULL,
    [Term Value]      FLOAT (53)     NULL,
    [Semester]        NVARCHAR (25)  NULL,
    [Extraction Date] DATE           NULL,
    [Extraction DoW]  NVARCHAR (3)   NULL,
    [Extraction Code] NVARCHAR (2)   NULL,
    [Process Date]    DATE           NULL
);

