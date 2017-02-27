CREATE TABLE [input].[Programs] (
    [ProgramsID]       INT            NOT NULL,
    [Program Code]    NVARCHAR (10)  NULL,
    [Program Name]    NVARCHAR (100) NULL,
    [Credential]      NVARCHAR (10)  NULL,
    [Credential Type] NVARCHAR (20)  NULL,
    [Major Code]      NVARCHAR (10)  NULL,
    [Major Name]      NVARCHAR (100) NULL,
    [Major CIP]       NVARCHAR (7)   NULL,
    [Academic Level]  NVARCHAR (3)   NULL,
    [Degree Code]     NVARCHAR (5)   NULL,
    [Catalog]         NVARCHAR (4)   NULL,
    [Start Date]      DATE           NULL,
    [End Date]        DATE           NULL,
    [Status]          NVARCHAR (3)   NULL,
    [Status Date]     DATE           NULL
);

