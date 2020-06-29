CREATE TABLE dw_fact.Error_Event 
(
    ErrorEventKey int NOT NULL,
    ErrorEventDateKey int NOT NULL,
    ScreenKey int NOT NULL,
    BatchKey int NOT NULL,
    ErrorDatetime DATETIME NOT NULL,

    SeverityScore int NOT NULL
);

CREATE TABLE dw_dim.Batches
(
    BatchKey int NOT NULL
);

CREATE TABLE dw_dim.Screens
(
    ScreenKey int NOT NULL,
    ScreenType int NOT NULL,
    ETLModule VARCHAR(50) NOT NULL,
    ScreenProcessingDefinition VARCHAR(100) NOT NULL,
    ExceptionAction VARCHAR(100) NOT NULL 
);

CREATE TABLE dw_fact.Error_Event_Detail
(
    ErrorEventKey int NOT NULL,
    ErrorEventDateKey int NOT NULL,
    ScreenKey int NOT NULL,
    BatchKey int NOT NULL,
    ErrorDatetime DATETIME NOT NULL,
    TableKey int NOT NULL,
    FieldKey int NOT NULL,
    RecordIdentifierKey int NOT NULL,

    ErrorCondition int NOT NULL
);