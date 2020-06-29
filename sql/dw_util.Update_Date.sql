/* -------------------------------------------------------- *
 * 
 * Object Name: dw_dim.Update_Date
 * Object Type: Stored Procedure
 * Creation Date: 2017-07-01
 *
 * Change log:
 * 2018-05-07 DMO A Added new columns for days to summer,
 *                    and days to end of terms
 * 2018-06-04 DMO A Added Fiscal Academic Year columns
 * 2019-09-11 DMO C Changed how Academic_Year, Fiscal_Academic_Year,
 *                      Reporting_Year, and Reporting_Academic_Year
 *                      are defined to align with 1G SBCCC 100.1.
 *                      https://www.nccommunitycolleges.edu/sbcccode/1g-sbccc-1001-definitions
 * 2019-09-12 DMO A Added Reporting_Year_FSS, Reporting_Academic_Year_FSS,
 *                        CE_Reporting_Year_FSS, and CE_Reporting_Academic_Year_FSS
 *                        to allow reporting on Fall, Spring, Summer. The 
 *                        non-FSS fields are Summer, Fall, Spring
 * -------------------------------------------------------- */
USE CCDW_HIST
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dw_util].[Update_Date] 
    @Start_Date DATE = NULL, 
    @End_Date DATE = NULL, 
    @Truncate_Table VARCHAR(5) = 'FALSE', 
    @Delete_From_Date DATE = NULL 
    --AUTHID SYSTEM_USER
AS BEGIN
/*
-- To REBUILD Date table, run this code.
EXECUTE
    dw_util.Update_Date @Start_Date = NULL, 
                        @End_Date = NULL, 
                        @Truncate_Table = 'TRUE', 
                        @Delete_From_Date = NULL 
                        ;


-- To UPDATE Date table, run this code.
EXECUTE
    dw_util.Update_Date Start_Date = NULL, 
                        End_Date = NULL, 
                        Truncate_Table = 'FALSE', 
                        Delete_From_Date = NULL 
                        ;
*/
    SET NOCOUNT ON

/* *
   -- FOR TESTING PURPOSES --
DECLARE @Start_Date DATE = CONVERT(DATE, '20000101', 112), -- NULL,
        @End_Date DATE = CONVERT(DATE, '20001231', 112), -- NULL,
        @Truncate_Table VARCHAR(5) = 'TRUE',
        @Delete_From_Date DATE = NULL
--* */

    -- These are the default dates when no term information is available
    DECLARE @d_Start_Date DATE = CONVERT(DATE, '19000101', 112), /* 'YYYYMMDD' */
            @d_End_Date   DATE = CONVERT(DATE, '20991231', 112)  /* 'YYYYMMDD' */

    -- These are the dates to use in the queries
    DECLARE @l_Start_Date DATE = NULL,
            @l_End_Date   DATE = NULL,
            @l_number_of_years INT = 0

    DECLARE @rows_removed  INT = 0,
            @rows_inserted INT = 0,
            @rows_modified INT = 0

    IF NOT (EXISTS (SELECT * 
                    FROM INFORMATION_SCHEMA.TABLES 
                    WHERE TABLE_SCHEMA = 'dw_dim' 
                    AND  TABLE_NAME = 'Date')) BEGIN
        CREATE TABLE dw_dim.Date (
            [Date_Key] INT NOT NULL PRIMARY KEY,
            [Full_Date] DATE NOT NULL,
            /* Date Formats */
            [DD] CHAR(2) NOT NULL,
            [DD_MON_YYYY] CHAR(11) NOT NULL,
            [DD_MON_YY] CHAR(9) NOT NULL,
            [MM] CHAR(2) NOT NULL,
            [MON_DD_YYYY] VARCHAR(30) NOT NULL,
            [MM_DD_YYYY] CHAR(10) NOT NULL,
            [MMYYYY] CHAR(6) NOT NULL,
            [MonYYYY] CHAR(7) NOT NULL,
            [YYYYMMDD] CHAR(8) NOT NULL,
            [YYYYMM] CHAR(6) NOT NULL,
            [YYYY] CHAR(4) NOT NULL,
            [YYMMDD] CHAR(6) NOT NULL,
            /* Day information */
            [Day_Num_of_Week] TINYINT NOT NULL,
            [Day_Num_of_Month] TINYINT NOT NULL,
            [Day_Num_of_Year] SMALLINT NOT NULL,
            [Day_Suffix] CHAR(2) NOT NULL,
            [Day_of_Week_Name] VARCHAR(10) NOT NULL,
            [Day_of_Week_Abbreviation] CHAR(3) NOT NULL,
            [Is_Weekday] CHAR(1) NOT NULL,
            [Is_Holiday] CHAR(1) NOT NULL,
            [Holiday_Text] VARCHAR(64) SPARSE,
            [Is_Last_Day_of_Week] CHAR(1) NOT NULL,
            [Is_Last_Day_of_Month] CHAR(1) NOT NULL,
            [Is_Last_Day_of_Year] CHAR(1) NOT NULL,
            [Previous_Day_Date] DATE NULL,
            [Previous_Day_Date_Key] INT NULL,
            [Next_Day_Date] DATE NULL,
            [Next_Day_Date_Key] INT NULL,
            [DOW_in_Month] TINYINT NULL,
            /* Week information */    
            [Week_Num_of_Month] TINYINT NULL,
            [Week_Num_of_Year] TINYINT NULL,
            [ISO_Week_of_Year] TINYINT NULL,
            /* Month information */
            [Month_Num_of_Year] TINYINT NULL,
            [Month_Name] [nvarchar](12) NULL,
            [Month_Name_Abbreviation] CHAR(3) NULL,
            [Month_Begin_Date] DATE NULL,
            [Month_Begin_Date_Key] INT NULL,
            [Month_End_Date] DATE NULL,
            [Month_End_Date_Key] INT NULL,
            /* Year information */
            [Year_Num] INT NULL,
            [Year_Begin_Date] DATE NULL,
            [Year_Begin_Date_Key] INT NULL,
            [Year_End_Date] DATE NULL,
            [Year_End_Date_Key] INT NULL,
            Previous_Year INT NULL,
            Next_Year INT NULL,
            /* ------------------------------------
            -         Term information         -
            ------------------------------------ */
            [Term_ID] VARCHAR(10) NULL,
            [Term_ID_Numeric] INT NULL,
            [Term_Abbreviation] VARCHAR(3) NULL,
            [Term_Start_Date] DATE NULL,
            [Term_Start_Date_Key] INT NULL,
            [Term_End_Date] DATE NULL,
            [Term_End_Date_Key] INT NULL,
            [Term_Name] VARCHAR(50) NULL,
            [Term_Description] VARCHAR(50) NULL,
            [Term_Type] VARCHAR(30) NULL,
            [Term_Index] SMALLINT NULL,
            [Term_Sort] SMALLINT NULL,
            [Academic_Year] VARCHAR(9) NULL,
            [Academic_Year_Start_Date] DATE NULL,
            [Academic_Year_Start_Date_Key] INT NULL,
            [Academic_Year_End_Date] DATE NULL,
            [Academic_Year_End_Date_Key] INT NULL,
            [Fiscal_Academic_Year] VARCHAR(9) NULL,                            /* 2018-06-04 DMO A */
            [Reporting_Year] CHAR(4) NULL,
            [Reporting_Academic_Year] VARCHAR(9) NULL,
            [Reporting_Year_FSS] CHAR(4) NULL,                                 /* 2019-09-12 DMO A */
            [Reporting_Academic_Year_FSS] VARCHAR(9) NULL,                     /* 2019-09-12 DMO A */
            [Semester] VARCHAR(30) NULL,
            [Is_Term_Start_Date] CHAR(1) NULL,
            [Is_Term_End_Date] CHAR(1) NULL,
            [Is_Term_Census_Date] CHAR(1) NULL,
            [Term_Census_Calculated] CHAR(1) NULL,
            [Is_Commencement_Date] CHAR(1) NULL,
            [Is_Regular_Term] CHAR(1) NULL,
            [Previous_Term_ID] VARCHAR(10) NULL,
            [Previous_Term_Start_Date] DATE NULL,
            [Previous_Term_Start_Date_Key] INT NULL,
            [Previous_Term_End_Date] DATE NULL,
            [Previous_Term_End_Date_Key] INT NULL,
            [Previous_Regular_Term_ID] VARCHAR(10) NULL,
            [Previous_Summer_Term_ID] VARCHAR(10) NULL,
            [Next_Term_ID] VARCHAR(10) NULL,
            [Next_Term_Start_Date] DATE NULL,
            [Next_Term_Start_Date_Key] INT NULL,
            [Next_Term_End_Date] DATE NULL,
            [Next_Term_End_Date_Key] INT NULL,
            [Next_Regular_Term_ID] VARCHAR(10) NULL,
            [Next_Summer_Term_ID] VARCHAR(10) NULL,
            [Same_Term_ID_Last_Year] VARCHAR(10) NULL,
            [Same_Term_ID_Next_Year] VARCHAR(10) NULL,
            [Days_to_Next_Term] SMALLINT NULL,
            [Days_to_Fall_Term] SMALLINT NULL,
            [Days_to_Spring_Term] SMALLINT NULL,
            [Days_to_Summer_Term] SMALLINT NULL,                            /* 2018-05-07 DMO A */
            [Business_Days_to_Census] SMALLINT NULL,
            [Business_Days_After_Census] SMALLINT NULL,
            [Week_Days_to_Census] SMALLINT NULL,
            [Week_Days_After_Census] SMALLINT NULL,
            [Days_to_Census] SMALLINT NULL,
            [Days_to_Next_Census] SMALLINT NULL,
            [Days_to_Fall_Census] SMALLINT NULL,
            [Days_to_Spring_Census] SMALLINT NULL,
            [Days_to_Summer_Census] SMALLINT NULL,                          /* 2018-05-07 DMO A */
            [Days_After_Census] SMALLINT NULL,
            [Days_After_Last_Census] SMALLINT NULL,
			[Days_to_End_of_Term] SMALLINT NULL,                            /* 2018-05-07 DMO A */
			[Days_to_Next_End_of_Term] SMALLINT NULL,                       /* 2018-05-07 DMO A */
			[Days_to_Fall_End_of_Term] SMALLINT NULL,                       /* 2018-05-07 DMO A */
			[Days_to_Spring_End_of_Term] SMALLINT NULL,                     /* 2018-05-07 DMO A */
			[Days_to_Summer_End_of_Term] SMALLINT NULL,                     /* 2018-05-07 DMO A */
            /* CE Term information */
            [CE_Term_ID] VARCHAR(10) NULL,
            [CE_Term_ID_Numeric] INT NULL,
            [CE_Term_Abbreviation] VARCHAR(3) NULL,
            [CE_Term_Start_Date] DATE NULL,
            [CE_Term_Start_Date_Key] INT NULL,
            [CE_Term_End_Date] DATE NULL,
            [CE_Term_End_Date_Key] INT NULL,
            [CE_Term_Name] VARCHAR(50) NULL,
            [CE_Term_Description] VARCHAR(50) NULL,
            [CE_Term_Type] VARCHAR(30) NULL,
            [CE_Term_Index] SMALLINT NULL,
            [CE_Term_Sort] SMALLINT NULL,
            [CE_Academic_Year] VARCHAR(9) NULL,
            [CE_Academic_Year_Start_Date] DATE NULL,
            [CE_Academic_Year_Start_Date_Key] INT NULL,
            [CE_Academic_Year_End_Date] DATE NULL,
            [CE_Academic_Year_End_Date_Key] INT NULL,
            [CE_Reporting_Year] CHAR(4) NULL,
            [CE_Reporting_Academic_Year] VARCHAR(9) NULL,
            [CE_Reporting_Year_FSS] CHAR(4) NULL,                              /* 2019-09-12 DMO A */
            [CE_Reporting_Academic_Year_FSS] VARCHAR(9) NULL,                  /* 2019-09-12 DMO A */
            [CE_Semester] VARCHAR(30) NULL,
            [CE_Is_Term_Start_Date] CHAR(1) NULL,
            [CE_Is_Term_End_Date] CHAR(1) NULL,
            [CE_Previous_Term_ID] VARCHAR(10) NULL,
            [CE_Previous_Term_Start_Date] DATE NULL,
            [CE_Previous_Term_Start_Date_Key] INT NULL,
            [CE_Previous_Term_End_Date] DATE NULL,
            [CE_Previous_Term_End_Date_Key] INT NULL,
            [CE_Next_Term_ID] VARCHAR(10) NULL,
            [CE_Next_Term_Start_Date] DATE NULL,
            [CE_Next_Term_Start_Date_Key] INT NULL,
            [CE_Next_Term_End_Date] DATE NULL,
            [CE_Next_Term_End_Date_Key] INT NULL,
            [CE_Same_Term_ID_Last_Year] VARCHAR(10) NULL,
            [CE_Same_Term_ID_Next_Year] VARCHAR(10) NULL
        );
    END
    ELSE BEGIN
        IF @Truncate_Table = 'TRUE' BEGIN
            PRINT N'Truncate table';
            DELETE FROM dw_dim.Date;
        END

        IF @Delete_From_Date IS NOT NULL BEGIN
            PRINT N'Delete from date ' + CONVERT(VARCHAR(10), @Delete_From_Date);
            DELETE FROM dw_dim.Date WHERE Full_Date >= @Delete_From_Date;
            set @rows_removed = @@ROWCOUNT;
            PRINT N'...deleted ' + CONVERT(VARCHAR(10), @rows_removed) + ' row(s)';
        END
    END

    IF @Start_Date IS NOT NULL BEGIN
        SET @l_Start_Date = @Start_Date;
    END
    ELSE BEGIN
        SELECT @l_Start_Date = COALESCE(DATEADD(dd, 1, MAX(Full_Date)), @d_Start_Date) FROM dw_dim.Date;

        IF @l_Start_Date IS NULL BEGIN
            SET @l_Start_Date = @d_Start_Date;
        END
    END

    IF @End_Date IS NOT NULL BEGIN
        SET @l_End_Date = @End_Date;
    END
    ELSE BEGIN
        IF (EXISTS (SELECT * 
                      FROM INFORMATION_SCHEMA.TABLES 
                     WHERE TABLE_SCHEMA = 'history' 
                       AND  TABLE_NAME = 'TERMS_Current')) BEGIN
            SELECT @l_End_Date = MAX([TERM.END.DATE]) FROM history.TERMS_Current;
        END

        IF @l_End_Date IS NULL BEGIN
            SET @l_End_Date = @d_End_Date;
        END
    END 

    -- this is just a holding table for intermediate calculations:
    DROP TABLE IF EXISTS #dim

    -- The following block (up to the term info) is adapted from the Date dimension script by Aaron Bertrand:
    -- https://www.mssqltips.com/sqlservertip/4054/creating-a-date-dimension-or-calendar-table-in-sql-server
    CREATE TABLE #dim
    (
        [full_date]  DATE PRIMARY KEY,
        [day]        AS DATEPART(DAY,      [full_date]),
        [month]      AS DATEPART(MONTH,    [full_date]),
        FirstOfMonth AS CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, [full_date]), 0)),
        LastOfMonth  AS CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, [full_date]) + 1, -1)),
        [MonthName]  AS DATENAME(MONTH,    [full_date]),
        [week]       AS DATEPART(WEEK,     [full_date]),
        [ISOweek]    AS DATEPART(ISO_WEEK, [full_date]),
        [DayOfWeek]  AS DATEPART(WEEKDAY,  [full_date]),
        [quarter]    AS DATEPART(QUARTER,  [full_date]),
        [year]       AS DATEPART(YEAR,     [full_date]),
        LastYear     AS DATEPART(YEAR,     [full_date]) - 1,
        NextYear     AS DATEPART(YEAR,     [full_date]) + 1,
        FirstOfYear  AS CONVERT(DATE, DATEADD(YEAR,  DATEDIFF(YEAR,  0, [full_date]), 0)),
        LastOfYear   AS CONVERT(DATE, DATEADD(YEAR,  DATEDIFF(YEAR,  0, [full_date]) + 1, -1)),
        Style112     AS CONVERT(CHAR(8),   [full_date], 112),
        Style101     AS CONVERT(CHAR(10),  [full_date], 101)
    );

    -- use the catalog views to generate as many rows as we need

    INSERT #dim([full_date])
    SELECT d
    FROM
    (
    SELECT d = DATEADD(DAY, rn - 1, @l_Start_Date)
    FROM
    (
        SELECT TOP (DATEDIFF(DAY, @l_Start_Date, @l_End_Date))
        rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
        FROM sys.all_objects AS s1
        CROSS JOIN sys.all_objects AS s2
        -- on my system this would support > 5 million days
        ORDER BY s1.[object_id]
    ) AS x
    ) AS y;


    -- create other useful index(es) here

    INSERT dw_dim.Date WITH (TABLOCKX)
    SELECT
        Date_Key                   = CONVERT(INT, Style112),
        Full_Date                  = [full_date],
        /* Date Formats */
        DD                         = SUBSTRING(Style112, 7, 2),
        DD_MON_YYYY                = CONVERT(CHAR(11), [full_date], 106),
        DD_MON_YY                  = SUBSTRING(Style112, 7, 2) 
                                        + '-' + UPPER(SUBSTRING([MonthName], 1, 3)) 
                                        + '-' + SUBSTRING(Style112, 3, 2),
        MM                         = LEFT(Style101, 2),
        MON_DD_YYYY                = CONVERT(CHAR(12), [full_date], 107), 
        MM_DD_YYYY                 = CONVERT(CHAR(10), [full_date], 101), 
        MMYYYY                     = CONVERT(CHAR(6), LEFT(Style101, 2)    + LEFT(Style112, 4)),
        MonYYYY                    = CONVERT(CHAR(7), LEFT([MonthName], 3) + LEFT(Style112, 4)),
        YYYYMMDD                   = Style112, 
        YYYYMM                     = SUBSTRING(Style112, 1, 6),
        YYYY                       = [year],
        YYMMDD                     = SUBSTRING(Style112, 3, 6),
        /* Day information */
        Day_Num_of_Week            = CONVERT(TINYINT, [DayOfWeek]),
        Day_Num_of_Month           = CONVERT(TINYINT, [day]),
        Day_Num_of_Year            = CONVERT(SMALLINT, DATEPART(DAYOFYEAR, [full_date])),
        Day_Suffix                 = CONVERT(CHAR(2), 
                                        CASE WHEN [day] / 10 = 1 THEN 'th' 
                                            ELSE CASE RIGHT([day], 1) 
                                                    WHEN '1' THEN 'st' 
                                                    WHEN '2' THEN 'nd'
                                                    WHEN '3' THEN 'rd' 
                                                    ELSE 'th' 
                                                    END 
                                            END),
        Day_of_Week_Name           = CONVERT(VARCHAR(10), DATENAME(WEEKDAY, [full_date])),
        Day_of_Week_Abbreviation   = SUBSTRING(DATENAME(WEEKDAY, [full_date]), 1, 3),

        Is_Weekday                 = CASE WHEN [DayOfWeek] IN (1,7) THEN 'N' ELSE 'Y' END,
        Is_Holiday                 = 'N',
        Holiday_Text               = 'Not a holiday',

        Is_Last_Day_of_Week        = CASE WHEN [DayOfWeek] = 6 THEN 'Y' ELSE 'N' END,
        Is_Last_Day_of_Month       = CASE WHEN [full_date] = (MAX([full_date]) OVER (PARTITION BY [year], [month])) THEN 'Y' ELSE 'N' END,
        Is_Last_Day_of_Year        = CASE WHEN [full_date] = LastOfYear THEN 'Y' ELSE 'N' END,

        Previous_Day_Date          = DATEADD(dd, -1, [full_date]),
        Previous_Day_Date_Key      = CONVERT(INT, CONVERT(CHAR(8), DATEADD(dd, -1, [full_date]), 112)),
        Next_Day_Date              = DATEADD(dd, 1, [full_date]),
        Next_Day_Date_Key          = CONVERT(INT, CONVERT(CHAR(8), DATEADD(dd, 1, [full_date]), 112)),

        DOW_in_Month               = CONVERT(TINYINT, ROW_NUMBER() OVER
                                         (PARTITION BY FirstOfMonth, [DayOfWeek] ORDER BY [full_date])),
        /* Week information */
        Week_Num_of_Month          = CONVERT(TINYINT, DENSE_RANK() OVER
                                         (PARTITION BY [year], [month] ORDER BY [week])),
        Week_Num_of_Year           = CONVERT(TINYINT, [week]),
        ISO_Week_of_Year           = CONVERT(TINYINT, ISOWeek),
        /* Month information */
        Month_Num_of_Year          = CONVERT(TINYINT, [month]),
        Month_Name                 = CONVERT(VARCHAR(10), [MonthName]),
        Month_Name_Abbreviation    = SUBSTRING([MonthName], 1, 3),
        Month_Begin_Date           = FirstOfMonth,
        Month_Begin_Date_Key       = CONVERT(INT, CONVERT(CHAR(8), FirstOfMonth, 112)),
        Month_End_Date             = MAX([full_date]) OVER (PARTITION BY [year], [month]),
        Month_End_Date_Key         = CONVERT(INT, CONVERT(CHAR(8), MAX([full_date]) OVER (PARTITION BY [year], [month]), 112)),
        /* Year information */
        Year_Num                   = [year],
        Year_Begin_Date            = FirstOfYear,
        Year_Begin_Date_Key        = CONVERT(INT, CONVERT(VARCHAR(8), FirstOfYear, 112)),
        Year_End_Date              = LastOfYear,
        Year_End_Date_Key          = CONVERT(INT, CONVERT(VARCHAR(8), LastOfYear, 112)),
        Previous_Year              = LastYear,
        Next_Year                  = NextYear,
        /* Term fields are all NULL for now */
        [Term_ID] = NULL,
        [Term_ID_Numeric] = NULL,
        [Term_Abbreviation] = NULL,
        [Term_Start_Date] = NULL,
        [Term_Start_Date_Key] = NULL,
        [Term_End_Date] = NULL,
        [Term_End_Date_Key] = NULL,
        [Term_Name] = NULL,
        [Term_Description] = NULL,
        [Term_Type] = NULL,
        [Term_Index] = NULL,
        [Term_Sort] = NULL,
        [Academic_Year] = NULL,
        [Academic_Year_Start_Date] = NULL,
        [Academic_Year_Start_Date_Key] = NULL,
        [Academic_Year_End_Date] = NULL,
        [Academic_Year_End_Date_Key] = NULL,
        [Fiscal_Academic_Year] = NULL,                                      /* 2018-06-04 DMO A */
        [Reporting_Year] = NULL,
        [Reporting_Academic_Year] = NULL,
        [Reporting_Year_FSS] = NULL,
        [Reporting_Academic_Year_FSS] = NULL,
        [Semester] = NULL,
        [Is_Term_Start_Date] = NULL,
        [Is_Term_End_Date] = NULL,
        [Is_Term_Census_Date] = NULL,
        [Term_Census_Calculated] = NULL,
        [Is_Commencement_Date] = NULL,
        [Is_Regular_Term] = NULL,
        [Previous_Term_ID] = NULL,
        [Previous_Term_Start_Date] = NULL,
        [Previous_Term_Start_Date_Key] = NULL,
        [Previous_Term_End_Date] = NULL,
        [Previous_Term_End_Date_Key] = NULL,
        [Previous_Regular_Term_ID] = NULL,
        [Previous_Summer_Term_ID] = NULL,
        [Next_Term_ID] = NULL,
        [Next_Term_Start_Date] = NULL,
        [Next_Term_Start_Date_Key] = NULL,
        [Next_Term_End_Date] = NULL,
        [Next_Term_End_Date_Key] = NULL,
        [Next_Regular_Term_ID] = NULL,
        [Next_Summer_Term_ID] = NULL,
        [Same_Term_ID_Last_Year] = NULL,
        [Same_Term_ID_Next_Year] = NULL,
        [Days_to_Next_Term] = NULL,
        [Days_to_Fall_Term] = NULL,
        [Days_to_Spring_Term] = NULL,
        [Days_to_Summer_Term] = NULL,                                       /* 2018-05-07 DMO A */
        [Business_Days_to_Census] = NULL,
        [Business_Days_After_Census] = NULL,
        [Week_Days_to_Census] = NULL,
        [Week_Days_After_Census] = NULL,
        [Days_to_Census] = NULL,
        [Days_to_Next_Census] = NULL,
        [Days_to_Fall_Census] = NULL,
        [Days_to_Spring_Census] = NULL,
        [Days_to_Summer_Census] = NULL,                                     /* 2018-05-07 DMO A */
        [Days_After_Census] = NULL,
        [Days_After_Last_Census] = NULL,
        [Days_to_End_of_Term] = NULL,                                       /* 2018-05-07 DMO A */
        [Days_to_Next_End_of_Term] = NULL,                                  /* 2018-05-07 DMO A */
        [Days_to_Fall_End_of_Term] = NULL,                                  /* 2018-05-07 DMO A */
        [Days_to_Spring_End_of_Term] = NULL,                                /* 2018-05-07 DMO A */
        [Days_to_Summer_End_of_Term] = NULL,                                /* 2018-05-07 DMO A */
        /* CE Term fields are all NULL for now */
        [CE_Term_ID] = NULL,
        [CE_Term_ID_Numeric] = NULL,
        [CE_Term_Abbreviation] = NULL,
        [CE_Term_Start_Date] = NULL,
        [CE_Term_Start_Date_Key] = NULL,
        [CE_Term_End_Date] = NULL,
        [CE_Term_End_Date_Key] = NULL,
        [CE_Term_Name] = NULL,
        [CE_Term_Description] = NULL,
        [CE_Term_Type] = NULL,
        [CE_Term_Index] = NULL,
        [CE_Term_Sort] = NULL,
        [CE_Academic_Year] = NULL,
        [CE_Academic_Year_Start_Date] = NULL,
        [CE_Academic_Year_Start_Date_Key] = NULL,
        [CE_Academic_Year_End_Date] = NULL,
        [CE_Academic_Year_End_Date_Key] = NULL,
        [CE_Reporting_Year] = NULL,
        [CE_Reporting_Academic_Year] = NULL,
        [CE_Reporting_Year_FSS] = NULL,
        [CE_Reporting_Academic_Year_FSS] = NULL,
        [CE_Semester] = NULL,
        [CE_Is_Term_Start_Date] = NULL,
        [CE_Is_Term_End_Date] = NULL,
        [CE_Previous_Term_ID] = NULL,
        [CE_Previous_Term_Start_Date] = NULL,
        [CE_Previous_Term_Start_Date_Key] = NULL,
        [CE_Previous_Term_End_Date] = NULL,
        [CE_Previous_Term_End_Date_Key] = NULL,
        [CE_Next_Term_ID] = NULL,
        [CE_Next_Term_Start_Date] = NULL,
        [CE_Next_Term_Start_Date_Key] = NULL,
        [CE_Next_Term_End_Date] = NULL,
        [CE_Next_Term_End_Date_Key] = NULL,
        [CE_Same_Term_ID_Last_Year] = NULL,
        [CE_Same_Term_ID_Next_Year] = NULL
    FROM #dim
    OPTION (MAXDOP 1);

    /* Add Holidays */
    ;WITH x AS
    (
    SELECT Date_Key, Full_Date, Is_Holiday, Holiday_Text, Year_Begin_Date,
        DOW_in_Month, [Month_Name], [Day_of_Week_Name], [Day_Num_of_Month],
        Last_DOW_in_Month = ROW_NUMBER() OVER
        (
        PARTITION BY Month_Begin_Date, Day_Num_of_Week
        ORDER BY Full_Date DESC
        )
    FROM dw_dim.Date
    )
    UPDATE x 
        SET Is_Holiday = 'Y', 
            Holiday_Text = CASE WHEN ([Full_Date] = Year_Begin_Date)
                                    THEN 'New Year''s Day'
                                WHEN ([DOW_in_Month] = 3 AND [Month_Name] = 'January' AND [Day_of_Week_Name] = 'Monday')
                                    THEN 'Martin Luther King Day'    -- (3rd Monday in January)
                                WHEN ([DOW_in_Month] = 3 AND [Month_Name] = 'February' AND [Day_of_Week_Name] = 'Monday')
                                    THEN 'President''s Day'          -- (3rd Monday in February)
                                WHEN ([Last_DOW_in_Month] = 1 AND [Month_Name] = 'May' AND [Day_of_Week_Name] = 'Monday')
                                    THEN 'Memorial Day'              -- (last Monday in May)
                                WHEN ([Month_Name] = 'July' AND [Day_Num_of_Month] = 4)
                                    THEN 'Independence Day'          -- (July 4th)
                                WHEN ([DOW_in_Month] = 1 AND [Month_Name] = 'September' AND [Day_of_Week_Name] = 'Monday')
                                    THEN 'Labor Day'                -- (first Monday in September)
                                WHEN ([DOW_in_Month] = 2 AND [Month_Name] = 'October' AND [Day_of_Week_Name] = 'Monday')
                                    THEN 'Columbus Day'              -- Columbus Day (second Monday in October)
                                WHEN ([Month_Name] = 'November' AND [Day_Num_of_Month] = 11)
                                    THEN 'Veterans'' Day'            -- Veterans' Day (November 11th)
                                WHEN ([DOW_in_Month] = 4 AND [Month_Name] = 'November' AND [Day_of_Week_Name] = 'Thursday')
                                    THEN 'Thanksgiving Day'          -- Thanksgiving Day (fourth Thursday in November)
                                WHEN ([Month_Name] = 'December' AND [Day_Num_of_Month] = 25)
                                    THEN 'Christmas Day'
                                END
        WHERE (Full_Date = Year_Begin_Date)
           OR ([DOW_in_Month] = 3        AND [Month_Name] = 'January'   AND [Day_of_Week_Name] = 'Monday')
           OR ([DOW_in_Month] = 3        AND [Month_Name] = 'February'  AND [Day_of_Week_Name] = 'Monday')
           OR ([Last_DOW_in_Month] = 1   AND [Month_Name] = 'May'       AND [Day_of_Week_Name] = 'Monday')
           OR ([Month_Name] = 'July'     AND [Day_Num_of_Month] = 4)
           OR ([DOW_in_Month] = 1        AND [Month_Name] = 'September' AND [Day_of_Week_Name] = 'Monday')
           OR ([DOW_in_Month] = 2        AND [Month_Name] = 'October'   AND [Day_of_Week_Name] = 'Monday')
           OR ([Month_Name] = 'November' AND [Day_Num_of_Month] = 11)
           OR ([DOW_in_Month] = 4        AND [Month_Name] = 'November'  AND [Day_of_Week_Name] = 'Thursday')
           OR ([Month_Name] = 'December' AND [Day_Num_of_Month] = 25);

    /* Set Thanksgiving holidays */
    UPDATE d SET Is_Holiday = 'Y', Holiday_Text = 'Black Friday'
    FROM dw_dim.Date AS d
    INNER JOIN
    (
    SELECT Date_Key, Year_Num, Day_Num_of_Year
    FROM dw_dim.Date
    WHERE Holiday_Text = 'Thanksgiving Day'
    ) AS src
    ON d.Year_Num = src.Year_Num
    AND d.Day_Num_of_Year = src.Day_Num_of_Year + 1;


    ;WITH x AS
    (
    SELECT d.Full_Date, d.Is_Holiday, d.Holiday_Text, h.Holiday_Name
        FROM dw_dim.Date AS d
        CROSS APPLY dw_util.GetEasterHolidays(d.Year_Num) AS h
        WHERE d.Full_Date = h.Full_Date
    )
    UPDATE x SET Is_Holiday = 'Y', Holiday_Text = Holiday_Name;


    MERGE INTO dw_dim.Date dd
        USING (SELECT DISTINCT
                      This_Date.Date_Key,
                      COALESCE(Current_Terms.[TERMS.ID],'None') AS Term_ID,
                      YEAR(Current_Terms.[TERM.START.DATE]) * 100 
                        + CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'SP' THEN 1 
                                WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'SU' THEN 2 
                                WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'FA' THEN 3 
                                WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'WI' THEN 4      /* 2018-07-13 DMO A */
                                WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 3) = 'CE1' THEN 1 
                                WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 3) = 'CE2' THEN 2 
                                WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 3) = 'CE3' THEN 3 
                                WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 3) = 'CE' THEN 4      /* 2018-07-13 DMO A */
                                ELSE NULL END AS Term_ID_Numeric,
                      Current_Terms.[TERM.START.DATE] AS Term_Start_Date,
                      CONVERT(CHAR(8), Current_Terms.[TERM.START.DATE], 112) AS Term_Start_Date_Key,
                      Current_Terms.[TERM.END.DATE] AS Term_End_Date,
                      CONVERT(CHAR(8), Current_Terms.[TERM.END.DATE], 112)   AS Term_End_Date_Key,
                      /* Term_Name */
                      CASE LTRIM(RTRIM(SUBSTRING(Current_Terms.[TERMS.ID], 5, 3))) 
                            WHEN 'FA' THEN 'Fall' 
                            WHEN 'SP' THEN 'Spring' 
                            WHEN 'SU' THEN 'Summer' 
                            WHEN 'WI' THEN 'Winter' 
                            ELSE 'Non-term' 
                            END + ' ' + LTRIM(RTRIM(SUBSTRING(Current_Terms.[TERMS.ID], 1, 4))) AS Term_Name,
                      Current_Terms.[TERM.DESC] AS Term_Description,
                      COALESCE(SUBSTRING(Current_Terms.[TERMS.ID], 5, 3), 'NA') AS Term_Abbreviation,
                      CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('FA', 'WI', 'SP', 'SU') THEN 'Curriculum' 
                           ELSE 'Non-Curriculum' END AS Term_Type,
                      /* Term_Index */
                      CASE WHEN LTRIM(RTRIM(SUBSTRING(Current_Terms.[TERMS.ID], 5, 3))) = 'WI'    /* 2019-10-15 DMO A */
                                THEN YEAR(Current_Terms.[TERM.START.DATE]) * 10                   /* 2019-10-15 DMO A */
                           ELSE This_date.Year_Num * 10 END                                       /* 2019-10-15 DMO C */
                          + CASE LTRIM(RTRIM(SUBSTRING(Current_Terms.[TERMS.ID], 5, 3)))
                            /*   WHEN 'CE1' THEN 0 */
                                 WHEN 'SP' THEN 1 
                            /*   WHEN 'CE2' THEN 3 */
                                 WHEN 'SU' THEN 4 
                            /*   WHEN 'CE3' THEN 5 */
                                 WHEN 'FA' THEN 6 
								 WHEN 'WI' THEN 8                                                 /* 2018-07-13 DMO A */
							/*   WHEN 'CE' THEN 9 */                                              /* 2018-07-13 DMO A */
                                 ELSE NULL END - 3 AS Term_Index,
                      CASE WHEN LTRIM(RTRIM(SUBSTRING(Current_Terms.[TERMS.ID], 5, 3))) = 'WI'    /* 2019-10-15 DMO A */
                                THEN YEAR(Current_Terms.[TERM.START.DATE]) * 10                   /* 2019-10-15 DMO A */
                           ELSE This_date.Year_Num * 10 END                                       /* 2019-10-15 DMO C */
                          + CASE LTRIM(RTRIM(SUBSTRING(Current_Terms.[TERMS.ID], 5, 3)))
                            /*   WHEN 'CE1' THEN 0 */
                                 WHEN 'SP' THEN 1 
                            /*   WHEN 'CE2' THEN 3 */
                                 WHEN 'SU' THEN 4
                            /*   WHEN 'CE3' THEN 5 */
                                 WHEN 'FA' THEN 6 
								 WHEN 'WI' THEN 8                                                 /* 2018-07-13 DMO A */
							/*   WHEN 'CE' THEN 9 */                                              /* 2018-07-13 DMO A */
                                 ELSE NULL END AS Term_Sort,
                      --YEAR(Current_Terms.[TERM.START.DATE]) * 10 
                      --  + CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'SP' THEN - 2 
                      --          WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'SU' THEN 1
                      --          WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'FA' THEN 3 
                      --          WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'WI' THEN 4      /* 2018-07-13 DMO A */
                      --          WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3) = 'CE1' THEN - 3 
                      --          WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3) = 'CE2' THEN 0 
                      --          WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3) = 'CE3' THEN 2 
                      --          WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 2) = 'CE' THEN 5      /* 2018-07-13 DMO A */
                      --          ELSE 6 END AS Term_Sort,
                      /* Academic_Year */
                      CASE WHEN Current_Terms.[TERMS.ID] IS NULL
                                THEN CASE WHEN This_Date.Year_Num < 1995 
                                               THEN NULL
                                          WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'
                                               THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY
                                          ELSE This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4)) END
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('WI', 'CE')                                     /* 2019-10-15 DMO A */
                                THEN CAST(YEAR(Current_Terms.[TERM.START.DATE]) AS CHAR(4)) + '-' +                           /* 2019-10-15 DMO A */
                                        CAST(YEAR(Current_Terms.[TERM.START.DATE]) + 1 AS CHAR(4))                            /* 2019-10-15 DMO A */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('FA', 'SP', 'SU')                               /* 2019-09-11 DMO C, 2019-10-15 DMO C */
                                THEN CASE WHEN MONTH(Current_Terms.[TERM.END.DATE]) >= 1                                      /* 2019-09-11 DMO A */
                                                  AND MONTH(Current_Terms.[TERM.END.DATE]) <= 6                               /* 2019-09-11 DMO A */
                                              THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY            /* 2019-09-11 DMO A */
                                          ELSE This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4))                    /* 2019-09-11 DMO A */
                                          END                                                                                 /* 2019-09-11 DMO A */
                                                                                                                              /* 2019-09-11 DMO D */
                           ELSE NULL END AS Academic_Year,
                      /* Academic_Year_Start_Date */
                      CONVERT(DATE, (CASE WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'
                                               THEN CAST(This_Date.Previous_Year AS CHAR(4))
                                          ELSE CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('WI', 'CE')            /* 2019-10-15 DMO C */
                                                         THEN CAST(YEAR(Current_Terms.[TERM.START.DATE]) AS CHAR(4))          /* 2019-10-15 DMO A */
                                                    ELSE This_Date.YYYY END END) + '0701', 112) AS Academic_Year_Start_Date,  /* 2019-10-15 DMO C */
                      /* Academic_Year_Start_Date_Key */
                      RTRIM(LTRIM(CASE WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630' 
                                            THEN CAST(This_Date.Previous_Year AS CHAR(4))
                                       ELSE CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('WI', 'CE')               /* 2019-10-15 DMO C */
                                                      THEN CAST(YEAR(Current_Terms.[TERM.START.DATE]) AS CHAR(4))             /* 2019-10-15 DMO A */
                                                 ELSE This_Date.YYYY END END)) + '0701' AS Academic_Year_Start_Date_Key,      /* 2019-10-15 DMO C */
                      /* Academic_Year_End_Date */
                      CONVERT(DATE, (CASE WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'
                                               THEN This_Date.YYYY
                                          ELSE CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('WI', 'CE')            /* 2019-10-15 DMO C */
                                                         THEN CAST(YEAR(Current_Terms.[TERM.START.DATE]) + 1 AS CHAR(4))      /* 2019-10-15 DMO A */
                                                    ELSE CAST(This_Date.Next_Year AS CHAR(4)) END END) + '0630', 112) AS Academic_Year_End_Date,/* 2019-10-15 DMO C */
                      /* Academic_Year_End_Date_Key */
                      RTRIM(LTRIM(CASE WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'
                                            THEN This_Date.YYYY
                                       ELSE CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('WI', 'CE')            /* 2019-10-15 DMO C */
                                                      THEN CAST(YEAR(Current_Terms.[TERM.START.DATE]) + 1 AS CHAR(4))      /* 2019-10-15 DMO A */
                                            ELSE CAST(This_Date.Next_Year AS CHAR(4)) END END)) + '0630' AS Academic_Year_End_Date_Key,/* 2019-10-15 DMO C */

                      /* Fiscal_Academic_Year */                                                                        /* 2018-06-04 DMO A */
                      CASE WHEN Current_Terms.[TERMS.ID] IS NULL                                                        /* 2018-06-04 DMO A */
                                THEN CASE WHEN This_Date.Year_Num < 1995                                                /* 2018-06-04 DMO A */
                                               THEN NULL                                                                /* 2018-06-04 DMO A */
                                          WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'                            /* 2018-06-04 DMO A */
                                               THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY     /* 2018-06-04 DMO A */
                                          ELSE This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4)) END          /* 2018-06-04 DMO A */
                                                                                                                        /* 2019-09-11 DMO D */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('WI', 'CE')                               /* 2019-10-15 DMO A */
                                THEN CAST(YEAR(Current_Terms.[TERM.START.DATE]) AS CHAR(4)) + '-' +                     /* 2019-10-15 DMO A */
                                        CAST(YEAR(Current_Terms.[TERM.START.DATE]) + 1 AS CHAR(4))                      /* 2019-10-15 DMO A */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('FA', 'SP', 'SU')                         /* 2019-09-11 DMO C, 2019-10-15 DMO C */
                                THEN CASE WHEN MONTH(Current_Terms.[TERM.END.DATE]) >= 1                                /* 2019-09-11 DMO C */
                                                  AND MONTH(Current_Terms.[TERM.END.DATE]) <= 6                         /* 2019-09-11 DMO A */
                                              THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY      /* 2019-09-11 DMO A */
                                          ELSE This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4))              /* 2019-09-11 DMO A */
                                          END                                                                           /* 2019-09-11 DMO A */
                           ELSE NULL END AS Fiscal_Academic_Year,                                                       /* 2018-06-04 DMO A */

                      /* Reporting_Year */
                      CASE WHEN Current_Terms.[TERMS.ID] IS NULL                                                        /* 2018-06-04 DMO C */
                                THEN CASE WHEN This_Date.Year_Num < 1995                                                /* 2018-06-04 DMO A */
                                               THEN NULL                                                                /* 2018-06-04 DMO A */
                                          WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'                            /* 2018-06-04 DMO A */
                                               THEN This_Date.Year_Num                                                  /* 2019-09-11 DMO C */
                                          ELSE This_Date.Year_Num + 1                                                   /* 2019-09-11 DMO C */
                                          END                                                                           /* 2018-06-04 DMO A */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('WI', 'CE')                               /* 2019-10-15 DMO A */
                                THEN YEAR(Current_Terms.[TERM.START.DATE]) + 1                                          /* 2019-10-15 DMO A */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('FA', 'SP', 'SU')                         /* 2019-09-11 DMO C, 2019-10-15 DMO C */
                                THEN CASE WHEN MONTH(Current_Terms.[TERM.END.DATE]) >= 1                                /* 2019-09-11 DMO C */
                                                  AND MONTH(Current_Terms.[TERM.END.DATE]) <= 6                         /* 2019-09-11 DMO A */
                                              THEN This_Date.Year_Num                                                   /* 2019-09-11 DMO A */
                                          ELSE This_Date.Year_Num + 1                                                   /* 2019-09-11 DMO C */
                                          END                                                                           /* 2019-09-11 DMO A */
                           ELSE NULL END AS Reporting_Year,                                                             /* 2018-06-04 DMO A */

                      CASE WHEN Current_Terms.[TERMS.ID] IS NULL                                                        /* 2018-06-04 DMO C */
                                THEN CASE WHEN This_Date.Year_Num < 1995                                                /* 2018-06-04 DMO A */
                                               THEN NULL                                                                /* 2018-06-04 DMO A */
                                          WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'                            /* 2018-06-04 DMO A */
                                               THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY     /* 2018-06-04 DMO A */
                                          ELSE This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4)) END          /* 2018-06-04 DMO A */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('WI', 'CE')                               /* 2019-10-15 DMO A */
                                THEN CAST(YEAR(Current_Terms.[TERM.START.DATE]) AS CHAR(4)) + '-' +                     /* 2019-10-15 DMO A */
                                        CAST(YEAR(Current_Terms.[TERM.START.DATE]) + 1 AS CHAR(4))                      /* 2019-10-15 DMO A */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('FA', 'SP', 'SU')                         /* 2019-09-11 DMO C, 2019-10-15 DMO C */
                                THEN CASE WHEN MONTH(Current_Terms.[TERM.END.DATE]) >= 1                                /* 2019-09-11 DMO C */
                                                  AND MONTH(Current_Terms.[TERM.END.DATE]) <= 6                         /* 2019-09-11 DMO A */
                                              THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY      /* 2019-09-11 DMO A */
                                          ELSE This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4))              /* 2019-09-11 DMO A */
                                          END                                                                           /* 2019-09-11 DMO A */
                           ELSE NULL END AS Reporting_Academic_Year,                                                    /* 2018-06-04 DMO C */

                      /* Reporting_Year_FSS */
                      CASE WHEN Current_Terms.[TERMS.ID] IS NULL                                                        /* 2019-09-12 DMO A */
                                THEN CASE WHEN This_Date.Year_Num < 1995                                                /* 2019-09-12 DMO A */
                                               THEN NULL                                                                /* 2019-09-12 DMO A */
                                          WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'                            /* 2019-09-12 DMO A */
                                               THEN This_Date.Year_Num                                                  /* 2019-09-12 DMO A */
                                          ELSE This_Date.Year_Num + 1                                                   /* 2019-09-12 DMO A */
                                          END                                                                           /* 2019-09-12 DMO A */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('WI', 'CE')                               /* 2019-10-15 DMO A */
                                THEN YEAR(Current_Terms.[TERM.START.DATE])                                              /* 2019-10-15 DMO A */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('FA')                                     /* 2019-09-12 DMO A */
                                THEN This_Date.Year_Num + 1                                                             /* 2019-09-12 DMO A */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('SP', 'SU')                               /* 2019-09-12 DMO A, 2019-10-15 DMO C */
                                THEN This_Date.Year_Num                                                                 /* 2019-09-12 DMO A */
                           ELSE NULL END AS Reporting_Year_FSS,                                                         /* 2019-09-12 DMO A */

                      CASE WHEN Current_Terms.[TERMS.ID] IS NULL                                                        /* 2019-09-12 DMO A */
                                THEN CASE WHEN This_Date.Year_Num < 1995                                                /* 2019-09-12 DMO A */
                                               THEN NULL                                                                /* 2019-09-12 DMO A */
                                          WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'                            /* 2019-09-12 DMO A */
                                               THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY     /* 2019-09-12 DMO A */
                                          ELSE This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4)) END          /* 2019-09-12 DMO A */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('WI', 'CE')                               /* 2019-10-15 DMO A */
                                THEN CAST(YEAR(Current_Terms.[TERM.START.DATE]) AS CHAR(4)) + '-' +                     /* 2019-10-15 DMO A */
                                        CAST(YEAR(Current_Terms.[TERM.START.DATE]) + 1 AS CHAR(4))                      /* 2019-10-15 DMO A */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('FA')                                     /* 2019-09-12 DMO C, 2019-10-15 DMO C */
                                THEN This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4))                        /* 2019-09-12 DMO A */
                           WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('WI', 'SP', 'SU')                         /* 2019-09-12 DMO A */
                                THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY                    /* 2019-09-12 DMO A */
                           ELSE NULL END AS Reporting_Academic_Year_FSS,                                                /* 2019-09-12 DMO A */

                      /* Semester */
                      CASE SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) 
                           WHEN 'CE' THEN 'Continuing Education' 
                           WHEN 'FA' THEN 'Fall' 
                           WHEN 'SP' THEN 'Spring' 
                           WHEN 'SU' THEN 'Summer' 
                           WHEN 'WI' THEN 'Winter' 
                           ELSE 'Non-term' END AS Semester,
                      /* Date Flags */
                      CASE WHEN Current_Terms.[TERM.START.DATE] = Full_Date THEN 'Y' ELSE 'N' END AS Is_Term_Start_Date, 
                      CASE WHEN Current_Terms.[TERM.END.DATE]   = Full_Date THEN 'Y' ELSE 'N' END AS Is_Term_End_Date, 
                      CASE WHEN COALESCE( Current_Terms.[TERM.CENSUS.DATES],
                                          DATEADD( dd
                                                 , ROUND( DATEDIFF( dd
                                                                  , Current_Terms.[TERM.START.DATE]
                                                                  , Current_Terms.[TERM.END.DATE]
                                                                  ) * 0.1
                                                        , 0
                                                        )
                                                 , Current_Terms.[TERM.START.DATE]
                                                 )
                                         ) = Full_Date
                                THEN 'Y' 
                           ELSE 'N' END AS Is_Term_Census_Date, 
                      CASE WHEN Current_Terms.[TERM.CENSUS.DATES] IS NULL
                                    AND Current_Terms.[TERM.START.DATE] IS NOT NULL
                                    AND Current_Terms.[TERM.END.DATE] IS NOT NULL
                                THEN 'Y'
                           ELSE 'N' END AS Term_Census_Calculated,
                      CASE WHEN Current_Terms.[TERM.COMMENCEMENT.DATE] = Full_Date THEN 'Y' ELSE 'N' END AS Is_Commencement_Date,
                      CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('FA', 'WI', 'SP', 'SU') THEN 'Y'
                                ELSE 'N' END AS Is_Regular_Term,
                      /* Previous Terms */
                      Previous_Terms.[TERMS.ID] AS Previous_Term_ID,
                      Previous_Terms.[TERM.START.DATE] AS Previous_Term_Start_Date,
                      CONVERT(VARCHAR(8), Previous_Terms.[TERM.START.DATE], 112) AS Previous_Term_Start_Date_Key,
                      Previous_Terms.[TERM.END.DATE] AS Previous_Term_End_Date,
                      CONVERT(VARCHAR(8), Previous_Terms.[TERM.END.DATE], 112) AS Previous_Term_End_Date_Key,
                      Previous_Regular_Terms.[TERMS.ID] AS Previous_Regular_Term_ID,
                      Previous_Summer_Terms.[TERMS.ID] AS Previous_Summer_Term_ID,
                      /* Next Terms */
                      Next_Terms.[TERMS.ID] AS Next_Term_ID,
                      Next_Terms.[TERM.START.DATE] AS Next_Term_Start_Date,
                      CONVERT(VARCHAR(8), Next_Terms.[TERM.START.DATE], 112) AS Next_Term_Start_Date_Key,
                      Next_Terms.[TERM.END.DATE] AS Next_Term_End_Date,
                      CONVERT(VARCHAR(8), Next_Terms.[TERM.END.DATE], 112) AS Next_Term_End_Date_Key,
                      Next_Regular_Terms.[TERMS.ID] AS Next_Regular_Term_ID,
                      Next_Summer_Terms.[TERMS.ID] AS Next_Summer_Term_ID,
                      (CASE WHEN Current_Terms.[TERMS.ID] IS NULL THEN 'None'
                            ELSE COALESCE(CONVERT(VARCHAR, DATEPART(yyyy, Current_Terms.[TERM.END.DATE]) + 1), '') + COALESCE(SUBSTRING(Current_Terms.[TERMS.ID], 5, 3), '')
                       END) AS Same_Term_ID_Next_Year,
                      (CASE WHEN Current_Terms.[TERMS.ID] IS NULL THEN 'None'
                            ELSE COALESCE(CONVERT(VARCHAR, DATEPART(yyyy, Current_Terms.[TERM.END.DATE]) - 1), '') + COALESCE(SUBSTRING(Current_Terms.[TERMS.ID], 5, 3), '')
                       END) AS Same_Term_ID_Last_Year,
                      /* Days to Term */
                      DATEDIFF(dd, This_Date.Full_Date, Next_Terms.[TERM.START.DATE]) AS Days_to_Next_Term,
                      CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'FA'
                                AND This_Date.Full_Date = Current_Terms.[TERM.START.DATE] 
                                THEN 0
                           ELSE DATEDIFF(dd, This_Date.Full_Date, Fall_Terms.[TERM.START.DATE])
                           END AS Days_to_Fall_Term,
                      CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'SP'
                                AND This_Date.Full_Date = Current_Terms.[TERM.START.DATE] 
                                THEN 0
                           ELSE DATEDIFF(dd, This_Date.Full_Date, Spring_Terms.[TERM.START.DATE])
                           END AS Days_to_Spring_Term,
                      CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'SU'                      /* 2018-05-07 DMO A */
                                AND This_Date.Full_Date = Current_Terms.[TERM.START.DATE]             /* 2018-05-07 DMO A */
                                THEN 0                                                                /* 2018-05-07 DMO A */
                           ELSE DATEDIFF(dd, This_Date.Full_Date, Summer_Terms.[TERM.START.DATE])     /* 2018-05-07 DMO A */
                           END AS Days_to_Summer_Term,                                                /* 2018-05-07 DMO A */   
                      /* Days to Census */
                      DATEDIFF(dd, This_Date.Full_Date, COALESCE(Current_Terms.[TERM.CENSUS.DATES], Next_Terms.[TERM.CENSUS.DATES])) AS Days_to_Census,
                      CASE WHEN This_Date.Full_Date <= Current_Terms.[TERM.CENSUS.DATES] 
                                THEN DATEDIFF(dd, This_Date.Full_Date, Current_Terms.[TERM.CENSUS.DATES])
                           ELSE DATEDIFF(dd, This_Date.Full_Date, 
                                             Next_Terms.[TERM.CENSUS.DATES]) END AS Days_to_Next_Census,
                      CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'FA'
                                AND This_Date.Full_Date <= Current_Terms.[TERM.CENSUS.DATES]
                                THEN DATEDIFF(dd, This_Date.Full_Date, Current_Terms.[TERM.CENSUS.DATES])
                           ELSE DATEDIFF(dd, This_Date.Full_Date, 
                                             Fall_Terms.[TERM.CENSUS.DATES]) END AS Days_to_Fall_Census,
                      CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'SP'
                                AND This_Date.Full_Date <= Current_Terms.[TERM.CENSUS.DATES]
                                THEN DATEDIFF(dd, This_Date.Full_Date, Current_Terms.[TERM.CENSUS.DATES])
                           ELSE DATEDIFF(dd, This_Date.Full_Date, 
                                             Spring_Terms.[TERM.CENSUS.DATES]) END AS Days_to_Spring_Census,
                      CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'SU'                               /* 2018-05-07 DMO A */
                                AND This_Date.Full_Date <= Current_Terms.[TERM.CENSUS.DATES]                   /* 2018-05-07 DMO A */
                                THEN DATEDIFF(dd, This_Date.Full_Date, Current_Terms.[TERM.CENSUS.DATES])      /* 2018-05-07 DMO A */
                           ELSE DATEDIFF(dd, This_Date.Full_Date,                                              /* 2018-05-07 DMO A */
                                             Summer_Terms.[TERM.CENSUS.DATES]) END AS Days_to_Summer_Census,   /* 2018-05-07 DMO A */
                      /* Days after Census */
                      DATEDIFF(dd, COALESCE(Current_Terms.[TERM.CENSUS.DATES], Previous_Terms.[TERM.CENSUS.DATES]), This_Date.Full_Date) AS Days_after_Census,
                      CASE WHEN This_Date.Full_Date >= Current_Terms.[TERM.CENSUS.DATES] 
                                THEN DATEDIFF(dd, Current_Terms.[TERM.CENSUS.DATES], This_Date.Full_Date)
                           ELSE DATEDIFF(dd, Previous_Terms.[TERM.CENSUS.DATES], This_Date.Full_Date) END AS Days_after_Last_Census,
                      /* Days to End of Term */                                                                  /* 2018-05-07 DMO A */
                      DATEDIFF(dd, This_Date.Full_Date, Current_Terms.[TERM.END.DATE]) AS Days_to_End_of_Term,   /* 2018-05-07 DMO A */   
                      DATEDIFF(dd, This_Date.Full_Date, Next_Terms.[TERM.END.DATE]) AS Days_to_Next_End_of_Term, /* 2018-05-07 DMO A */
                      CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'FA'                                 /* 2018-05-07 DMO A */
                                THEN DATEDIFF(dd, This_Date.Full_Date, Current_Terms.[TERM.END.DATE])            /* 2018-05-07 DMO A */
                           ELSE DATEDIFF(dd, This_Date.Full_Date, Fall_Terms.[TERM.END.DATE])                    /* 2018-05-07 DMO A */
                           END AS Days_to_Fall_End_of_Term,                                                      /* 2018-05-07 DMO A */   
                      CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'SP'                                 /* 2018-05-07 DMO A */
                                THEN DATEDIFF(dd, This_Date.Full_Date, Current_Terms.[TERM.END.DATE])            /* 2018-05-07 DMO A */
                           ELSE DATEDIFF(dd, This_Date.Full_Date, Spring_Terms.[TERM.END.DATE])                  /* 2018-05-07 DMO A */
                           END AS Days_to_Spring_End_of_Term,                                                    /* 2018-05-07 DMO A */   
                      CASE WHEN SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) = 'SU'                                 /* 2018-05-07 DMO A */
                                THEN DATEDIFF(dd, This_Date.Full_Date, Current_Terms.[TERM.END.DATE])            /* 2018-05-07 DMO A */
                           ELSE DATEDIFF(dd, This_Date.Full_Date, Summer_Terms.[TERM.END.DATE])                  /* 2018-05-07 DMO A */
                           END AS Days_to_Summer_End_of_Term,                                                    /* 2018-05-07 DMO A */   
                      /* CE Term information */
                      COALESCE(Current_Terms_CE.[TERMS.ID],'None') AS CE_Term_ID,
                      YEAR(Current_Terms_CE.[TERM.START.DATE]) * 100 
                        + CASE  WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3) = 'CE1' THEN 1 
                                WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3) = 'CE2' THEN 2 
                                WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3) = 'CE3' THEN 3
                                WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3) = 'CE' THEN 4   /* 2018-07-13 DMO A */
                                ELSE NULL END AS CE_Term_ID_Numeric,
                      Current_Terms_CE.[TERM.START.DATE] AS CE_Term_Start_Date,
                      CONVERT(CHAR(8), Current_Terms_CE.[TERM.START.DATE], 112) AS CE_Term_Start_Date_Key,
                      Current_Terms_CE.[TERM.END.DATE] AS CE_Term_End_Date,
                      CONVERT(CHAR(8), Current_Terms_CE.[TERM.END.DATE], 112)   AS CE_Term_End_Date_Key,
                      /* Term_Name */
                      CASE LTRIM(RTRIM(SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3))) 
                            WHEN 'CE' THEN 'Continuing Education' 
                            WHEN 'CE1' THEN 'Continuing Education 1' 
                            WHEN 'CE2' THEN 'Continuing Education 2' 
                            WHEN 'CE3' THEN 'Continuing Education 3' 
                            ELSE 'Non-term' 
                            END + ' ' + LTRIM(RTRIM(SUBSTRING(Current_Terms_CE.[TERMS.ID], 1, 4))) AS CE_Term_Name,
                      Current_Terms_CE.[TERM.DESC] AS CE_Term_Description,
                      COALESCE(SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3), 'NA') AS CE_Term_Abbreviation,
                      CASE WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 2) IN ('CE') THEN 'Continuing Education' 
                           ELSE 'Non-Continuing Education' END AS CE_Term_Type,
                      /* Term_Index */
                      YEAR(Current_Terms_CE.[TERM.START.DATE]) * 10 
                          + CASE LTRIM(RTRIM(SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3)))
                                 WHEN 'CE1' THEN 0 
                                 WHEN 'CE2' THEN 3
                                 WHEN 'CE3' THEN 5 
                                 WHEN 'CE' THEN 9                                                    /* 2018-07-13 DMO A */
                                 ELSE NULL END -3 AS CE_Term_Index,
                      YEAR(Current_Terms_CE.[TERM.START.DATE]) * 10 
                          + CASE LTRIM(RTRIM(SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3)))
                                 WHEN 'CE1' THEN 0 
                                 WHEN 'CE2' THEN 3 
                                 WHEN 'CE3' THEN 5 
                                 WHEN 'CE' THEN 9                                                    /* 2018-07-13 DMO A */
                                ELSE 4 END AS CE_Term_Sort,
                      /* CE_Academic_Year */
                      CASE WHEN Current_Terms_CE.[TERMS.ID] IS NULL                                                           /* 2019-09-11 DMO C */
                                THEN CASE WHEN This_Date.Year_Num < 1995                                                      /* 2019-09-11 DMO A */ 
                                               THEN NULL                                                                      /* 2019-09-11 DMO A */
                                          WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'                                  /* 2019-09-11 DMO A */
                                               THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY           /* 2019-09-11 DMO A */
                                          ELSE This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4)) END                /* 2019-09-11 DMO A */
                           WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 2) IN ('CE')                                        /* 2019-09-11 DMO C */
                                THEN CASE WHEN MONTH(Current_Terms_CE.[TERM.END.DATE]) >= 1                                   /* 2019-09-11 DMO C */
                                                  AND MONTH(Current_Terms_CE.[TERM.END.DATE]) <= 6                            /* 2019-09-11 DMO A */
                                              THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY            /* 2019-09-11 DMO C */
                                          ELSE This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4))                    /* 2019-09-11 DMO C */
                                          END
                           ELSE NULL END AS CE_Academic_Year,
                      /* CE_Academic_Year_Start_Date */
                      CONVERT( DATE, 
                               CAST(Current_Terms_CE.[TERM.REPORTING.YEAR] AS CHAR(4)) + '0701',
                               112) AS CE_Academic_Year_Start_Date,
                      /* CE_Academic_Year_Start_Date_Key */
                      CAST(Current_Terms_CE.[TERM.REPORTING.YEAR] AS CHAR(4)) + '0701' AS CE_Academic_Year_Start_Date_Key,
                      /* CE_Academic_Year_End_Date */
                      CONVERT( DATE, 
                               CAST(Current_Terms_CE.[TERM.REPORTING.YEAR] + 1 AS CHAR(4)) + '0630', 
                               112) AS CE_Academic_Year_End_Date,
                      /* CE_Academic_Year_End_Date_Key */
                      CAST(Current_Terms_CE.[TERM.REPORTING.YEAR] + 1 AS CHAR(4)) + '0630' AS CE_Academic_Year_End_Date_Key,

                      /* CE_Reporting_Year */
                      CASE WHEN Current_Terms_CE.[TERMS.ID] IS NULL                                                           /* 2019-09-11 DMO C */
                                THEN CASE WHEN This_Date.Year_Num < 1995                                                      /* 2019-09-11 DMO A */ 
                                               THEN NULL                                                                      /* 2019-09-11 DMO A */
                                          WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'                                  /* 2019-09-11 DMO A */
                                               THEN This_Date.Year_Num                                                        /* 2019-09-11 DMO A */
                                          ELSE This_Date.Year_Num + 1                                                         /* 2019-09-11 DMO A */
                                          END                                                                                 /* 2019-09-11 DMO A */
                           WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 2) IN ('CE')                                        /* 2019-09-11 DMO A */
                                THEN CASE WHEN MONTH(Current_Terms_CE.[TERM.END.DATE]) >= 1                                   /* 2019-09-11 DMO A */
                                                  AND MONTH(Current_Terms_CE.[TERM.END.DATE]) <= 6                            /* 2019-09-11 DMO A */
                                              THEN This_Date.Year_Num                                                         /* 2019-09-11 DMO A */
                                          ELSE This_Date.Year_Num + 1                                                         /* 2019-09-11 DMO A */
                                          END
                           ELSE NULL END AS CE_Reporting_Year,
                      CASE WHEN Current_Terms_CE.[TERMS.ID] IS NULL                                                           /* 2019-09-11 DMO C */
                                THEN CASE WHEN This_Date.Year_Num < 1995                                                      /* 2019-09-11 DMO A */ 
                                               THEN NULL                                                                      /* 2019-09-11 DMO A */
                                          WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'                                  /* 2019-09-11 DMO A */
                                               THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY           /* 2019-09-11 DMO A */
                                          ELSE This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4)) END                /* 2019-09-11 DMO A */
                           WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 2) IN ('CE')                                        /* 2019-09-11 DMO C */
                                THEN CASE WHEN MONTH(Current_Terms_CE.[TERM.END.DATE]) >= 1                                   /* 2019-09-11 DMO C */
                                                  AND MONTH(Current_Terms_CE.[TERM.END.DATE]) <= 6                            /* 2019-09-11 DMO A */
                                              THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY            /* 2019-09-11 DMO C */
                                          ELSE This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4))                    /* 2019-09-11 DMO C */
                                          END
                           ELSE NULL END AS CE_Reporting_Academic_Year,

                      /* CE_Reporting_Year_FSS */
                      CASE WHEN Current_Terms_CE.[TERMS.ID] IS NULL                                                     /* 2019-09-12 DMO A */
                                THEN CASE WHEN This_Date.Year_Num < 1995                                                /* 2019-09-12 DMO A */
                                               THEN NULL                                                                /* 2019-09-12 DMO A */
                                          WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'                            /* 2019-09-12 DMO A */
                                               THEN This_Date.Year_Num                                                  /* 2019-09-12 DMO A */
                                          ELSE This_Date.Year_Num + 1                                                   /* 2019-09-12 DMO A */
                                          END                                                                           /* 2019-09-12 DMO A */
                           WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3) IN ('CE3')                                 /* 2019-09-12 DMO A */
                                THEN This_Date.Year_Num + 1                                                             /* 2019-09-12 DMO A */
                           WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 2) IN ('CE')                                  /* 2019-09-12 DMO A */
                                THEN This_Date.Year_Num                                                                 /* 2019-09-12 DMO A */
                           ELSE NULL END AS CE_Reporting_Year_FSS,                                                      /* 2019-09-12 DMO A */

                      CASE WHEN Current_Terms_CE.[TERMS.ID] IS NULL                                                     /* 2019-09-12 DMO A */
                                THEN CASE WHEN This_Date.Year_Num < 1995                                                /* 2019-09-12 DMO A */
                                               THEN NULL                                                                /* 2019-09-12 DMO A */
                                          WHEN SUBSTRING(This_Date.YYYYMMDD, 5, 4) <= '0630'                            /* 2019-09-12 DMO A */
                                               THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY     /* 2019-09-12 DMO A */
                                          ELSE This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4)) END          /* 2019-09-12 DMO A */
                           WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3) IN ('CE3')                                 /* 2019-09-12 DMO A */
                                THEN This_Date.YYYY + '-' + CAST(This_Date.Next_Year AS CHAR(4))                        /* 2019-09-12 DMO A */
                           WHEN SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 2) IN ('CE')                                  /* 2019-09-12 DMO A */
                                THEN CAST(This_Date.Previous_Year AS CHAR(4)) + '-' + This_Date.YYYY                    /* 2019-09-12 DMO A */
                           ELSE NULL END AS CE_Reporting_Academic_Year_FSS,                                             /* 2019-09-12 DMO A */

                      /* Semester */
                      CASE SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 2) 
                           WHEN 'CE' THEN 'Continuing Education' 
                           ELSE 'Non-term' END AS CE_Semester,
                      /* Date Flags */
                      CASE WHEN Current_Terms_CE.[TERM.START.DATE] = Full_Date THEN 'Y' ELSE 'N' END AS CE_Is_Term_Start_Date, 
                      CASE WHEN Current_Terms_CE.[TERM.END.DATE]   = Full_Date THEN 'Y' ELSE 'N' END AS CE_Is_Term_End_Date, 
                      /* Previous Terms */
                      Previous_Terms_CE.[TERMS.ID] AS CE_Previous_Term_ID,
                      Previous_Terms_CE.[TERM.START.DATE] AS CE_Previous_Term_Start_Date,
                      CONVERT(VARCHAR(8), Previous_Terms_CE.[TERM.START.DATE], 112) AS CE_Previous_Term_Start_Date_Key,
                      Previous_Terms_CE.[TERM.END.DATE] AS CE_Previous_Term_End_Date,
                      CONVERT(VARCHAR(8), Previous_Terms_CE.[TERM.END.DATE], 112) AS CE_Previous_Term_End_Date_Key,
                      /* Next Terms */
                      Next_Terms_CE.[TERMS.ID] AS CE_Next_Term_ID,
                      Next_Terms_CE.[TERM.START.DATE] AS CE_Next_Term_Start_Date,
                      CONVERT(VARCHAR(8), Next_Terms_CE.[TERM.START.DATE], 112) AS CE_Next_Term_Start_Date_Key,
                      Next_Terms_CE.[TERM.END.DATE] AS CE_Next_Term_End_Date,
                      CONVERT(VARCHAR(8), Next_Terms_CE.[TERM.END.DATE], 112) AS CE_Next_Term_End_Date_Key,
                      (CASE WHEN Current_Terms_CE.[TERMS.ID] IS NULL THEN 'None'
                            ELSE COALESCE(CONVERT(VARCHAR, DATEPART(yyyy, Current_Terms_CE.[TERM.END.DATE]) + 1), '') + COALESCE(SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3), '')
                       END) AS CE_Same_Term_ID_Next_Year,
                      (CASE WHEN Current_Terms_CE.[TERMS.ID] IS NULL THEN 'None'
                            ELSE COALESCE(CONVERT(VARCHAR, DATEPART(yyyy, Current_Terms_CE.[TERM.END.DATE]) - 1), '') + COALESCE(SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 3), '')
                       END) AS CE_Same_Term_ID_Last_Year
                 FROM dw_dim.Date This_Date
                 LEFT JOIN history.TERMS_Current Current_Terms
                      ON (This_Date.Full_Date BETWEEN 
                                  (CASE WHEN Current_Terms.[TERMS.ID] = '1972SU' 
                                             THEN CONVERT(DATE, '19720705', 112)
                                        ELSE Current_Terms.[TERM.START.DATE] END)
                              AND (CASE WHEN Current_Terms.[TERMS.ID] = '1972SU' 
                                             THEN CONVERT(DATE, '19720920', 112)
                                        ELSE Current_Terms.[TERM.END.DATE] END)
                          AND SUBSTRING(Current_Terms.[TERMS.ID], 5, 2) IN ('FA', 'SP', 'SU', 'WI'))
                 /* This joins the previous CU term */
                 LEFT JOIN history.TERMS_Current Previous_Terms
                      ON (Previous_Terms.[TERM.END.DATE] =
                                (SELECT MAX(pt_s.[TERM.END.DATE])
                                   FROM history.TERMS_Current pt_s
                                  WHERE pt_s.[TERM.END.DATE] < This_Date.Full_Date
                                    AND SUBSTRING(pt_s.[TERMS.ID], 5, 2) IN ('FA', 'SP', 'SU', 'WI'))
                          AND SUBSTRING(Previous_Terms.[TERMS.ID], 5, 2) IN ('FA', 'SP', 'SU', 'WI') )
                /* This joins the previous summer CU term */
                 LEFT JOIN history.TERMS_Current Previous_Summer_Terms
                      ON (Previous_Summer_Terms.[TERM.END.DATE] =
                                (SELECT MAX(pst_s.[TERM.END.DATE])
                                   FROM history.TERMS_Current pst_s
                                  WHERE pst_s.[TERM.END.DATE] < This_Date.Full_Date
                                    AND SUBSTRING(pst_s.[TERMS.ID], 5, 2) IN ('SU'))
                          AND SUBSTRING(Previous_Summer_Terms.[TERMS.ID], 5, 2) IN ('SU') ) 
                 /* This joins the previous regular CU term */
                 LEFT JOIN history.TERMS_Current Previous_Regular_Terms
                      ON (Previous_Regular_Terms.[TERM.END.DATE] =
                                (SELECT MAX(prt_s.[TERM.END.DATE])
                                   FROM history.TERMS_Current prt_s
                                  WHERE prt_s.[TERM.END.DATE] < This_Date.Full_Date
                                    AND SUBSTRING(prt_s.[TERMS.ID], 5, 2) IN ('FA', 'SP'))
                          AND SUBSTRING(Previous_Regular_Terms.[TERMS.ID], 5, 2) IN ('FA', 'SP') )
                /* This joins the next CU term */
                 LEFT JOIN history.TERMS_Current Next_Terms
                      ON (Next_Terms.[TERM.START.DATE] =
                                (SELECT MIN(nt_s.[TERM.START.DATE])
                                   FROM history.TERMS_Current nt_s
                                  WHERE nt_s.[TERM.START.DATE] > This_Date.Full_Date
                                    AND SUBSTRING(nt_s.[TERMS.ID], 5, 2) IN ('FA', 'SP', 'SU', 'WI'))
                          AND SUBSTRING(Next_Terms.[TERMS.ID], 5, 2) IN ('FA', 'SP', 'SU', 'WI') ) 
                /* This joins the next summer CU term */
                 LEFT JOIN history.TERMS_Current Next_Summer_Terms
                      ON (Next_Summer_Terms.[TERM.START.DATE] =
                                (SELECT MIN(nst_s.[TERM.START.DATE])
                                   FROM history.TERMS_Current nst_s
                                  WHERE nst_s.[TERM.START.DATE] > This_Date.Full_Date
                                    AND SUBSTRING(nst_s.[TERMS.ID], 5, 2) IN ('SU'))
                          AND SUBSTRING(Next_Summer_Terms.[TERMS.ID], 5, 2) IN ('SU') ) 
                /* This joins the next regular CU term */
                 LEFT JOIN history.TERMS_Current Next_Regular_Terms
                      ON (Next_Regular_Terms.[TERM.START.DATE] =
                                (SELECT MIN(nrt_s.[TERM.START.DATE])
                                   FROM history.TERMS_Current nrt_s
                                  WHERE nrt_s.[TERM.START.DATE] > This_Date.Full_Date
                                    AND SUBSTRING(nrt_s.[TERMS.ID], 5, 2) IN ('FA', 'SP'))
                          AND SUBSTRING(Next_Regular_Terms.[TERMS.ID], 5, 2) IN ('FA', 'SP') ) 
                /* This joins the fall term of the current year unless we are past the start date of that term */
                 LEFT JOIN history.TERMS_Current Fall_Terms
                      ON (Fall_Terms.[TERMS.ID] =
                                (SELECT MIN(pt_s.[TERMS.ID])
                                   FROM history.TERMS_Current pt_s
                                  WHERE pt_s.[TERM.START.DATE] > This_Date.Full_Date
                                    AND SUBSTRING(pt_s.[TERMS.ID], 5, 2) = 'FA') ) 
                /* This joins the spring term of the current year unless we are past the start date of the term */
                 LEFT JOIN history.TERMS_Current Spring_Terms
                      ON (Spring_Terms.[TERMS.ID] =
                                (SELECT MIN(pt_s.[TERMS.ID])
                                   FROM history.TERMS_Current pt_s
                                  WHERE pt_s.[TERM.START.DATE] > This_Date.Full_Date
                                    AND SUBSTRING(pt_s.[TERMS.ID], 5, 2) = 'SP') ) 
                /* This joins the summer term of the current year unless we are past the start date of the term 2018-05-07 DMO A */
                 LEFT JOIN history.TERMS_Current Summer_Terms                                                /* 2018-05-07 DMO A */
                      ON (Summer_Terms.[TERMS.ID] =                                                          /* 2018-05-07 DMO A */
                                (SELECT MIN(pt_s.[TERMS.ID])                                                 /* 2018-05-07 DMO A */
                                   FROM history.TERMS_Current pt_s                                           /* 2018-05-07 DMO A */
                                  WHERE pt_s.[TERM.START.DATE] > This_Date.Full_Date                         /* 2018-05-07 DMO A */
                                    AND SUBSTRING(pt_s.[TERMS.ID], 5, 2) = 'SU') )                           /* 2018-05-07 DMO A */
                 /* This joins the current CE term */
                 LEFT JOIN history.TERMS_Current Current_Terms_CE
                      ON (This_Date.Full_Date BETWEEN Current_Terms_CE.[TERM.START.DATE] AND Current_Terms_CE.[TERM.END.DATE]
                          AND SUBSTRING(Current_Terms_CE.[TERMS.ID], 5, 2) = 'CE')
                 /* This joins the previous CE term */
                 LEFT JOIN history.TERMS_Current Previous_Terms_CE
                      ON (Previous_Terms_CE.[TERM.END.DATE] =
                                (SELECT MAX(pt_s.[TERM.END.DATE])
                                   FROM history.TERMS_Current pt_s
                                  WHERE pt_s.[TERM.END.DATE] < This_Date.Full_Date
                                    AND SUBSTRING(pt_s.[TERMS.ID], 5, 2) = 'CE')
                          AND SUBSTRING(Previous_Terms_CE.[TERMS.ID], 5, 2) = 'CE') 
                 /* This joins the next CE term */
                 LEFT JOIN history.TERMS_Current Next_Terms_CE
                      ON (Next_Terms_CE.[TERM.START.DATE] =
                                (SELECT MIN(pt_s.[TERM.START.DATE])
                                   FROM history.TERMS_Current pt_s
                                  WHERE pt_s.[TERM.START.DATE] > This_Date.Full_Date
                                    AND SUBSTRING(pt_s.[TERMS.ID], 5, 2) = 'CE')
                          AND SUBSTRING(Next_Terms_CE.[TERMS.ID], 5, 2) = 'CE') 
        ) tc
        ON (dd.Date_Key = tc.Date_Key)
        WHEN MATCHED THEN 
            UPDATE
            SET dd.Term_ID = tc.Term_ID,
                dd.Term_ID_Numeric = tc.Term_ID_Numeric,
                dd.Term_Start_Date = tc.Term_Start_Date,
                dd.Term_Start_Date_Key = tc.Term_Start_Date_Key,
                dd.Term_End_Date = tc.Term_End_Date,
                dd.Term_End_Date_Key = tc.Term_End_Date_Key,
                dd.Term_Name = tc.Term_Name,
                dd.Term_Description = tc.Term_Description,
                dd.Term_Abbreviation = tc.Term_Abbreviation,
                dd.Term_Type = tc.Term_Type,
                dd.Term_Index = tc.Term_Index,
                dd.Term_Sort = tc.Term_Sort,
                dd.Academic_Year = tc.Academic_Year,
                dd.Academic_Year_Start_Date = tc.Academic_Year_Start_Date,
                dd.Academic_Year_Start_Date_Key = tc.Academic_Year_Start_Date_Key,
                dd.Academic_Year_End_Date = tc.Academic_Year_End_Date,
                dd.Academic_Year_End_Date_Key = tc.Academic_Year_End_Date_Key,
                dd.Fiscal_Academic_Year = tc.Fiscal_Academic_Year,                    /* 2018-06-04 DMO A */
                dd.Reporting_Year = tc.Reporting_Year,
                dd.Reporting_Academic_Year = tc.Reporting_Academic_Year,
                dd.Reporting_Year_FSS = tc.Reporting_Year_FSS,                        /* 2019-09-12 DMO A */
                dd.Reporting_Academic_Year_FSS = tc.Reporting_Academic_Year_FSS,      /* 2019-09-12 DMO A */
                dd.Semester = tc.Semester,
                dd.Is_Term_Start_Date = tc.Is_Term_Start_Date,
                dd.Is_Term_End_Date = tc.Is_Term_End_Date,
                dd.Is_Term_Census_Date = tc.Is_Term_Census_Date,
                dd.Term_Census_Calculated = tc.Term_Census_Calculated,
                dd.Is_Commencement_Date = tc.Is_Commencement_Date,
                dd.Is_Regular_Term = tc.Is_Regular_Term,
                dd.Previous_Term_ID = tc.Previous_Term_ID,
                dd.Previous_Term_Start_Date = tc.Previous_Term_Start_Date,
                dd.Previous_Term_Start_Date_Key = tc.Previous_Term_Start_Date_Key,
                dd.Previous_Term_End_Date = tc.Previous_Term_End_Date,
                dd.Previous_Term_End_Date_Key = tc.Previous_Term_End_Date_Key,
                dd.Previous_Regular_Term_ID = tc.Previous_Regular_Term_ID,
                dd.Previous_Summer_Term_ID = tc.Previous_Summer_Term_ID,
                dd.Next_Term_ID = tc.Next_Term_ID,
                dd.Next_Term_Start_Date = tc.Next_Term_Start_Date,
                dd.Next_Term_Start_Date_Key = tc.Next_Term_Start_Date_Key,
                dd.Next_Term_End_Date = tc.Next_Term_End_Date,
                dd.Next_Term_End_Date_Key = tc.Next_Term_End_Date_Key,
                dd.Next_Regular_Term_ID = tc.Next_Regular_Term_ID,
                dd.Next_Summer_Term_ID = tc.Next_Summer_Term_ID,
                dd.Same_Term_ID_Last_Year = tc.Same_Term_ID_Last_Year,
                dd.Same_Term_ID_Next_Year = tc.Same_Term_ID_Next_Year,
                dd.Days_to_Next_Term = tc.Days_to_Next_Term,
                dd.Days_to_Fall_Term = tc.Days_to_Fall_Term,
                dd.Days_to_Spring_Term = tc.Days_to_Spring_Term,
                dd.Days_to_Summer_Term = tc.Days_to_Summer_Term,                      /* 2018-05-07 DMO A */
                dd.Days_to_Census = tc.Days_to_Census,
                dd.Days_to_Next_Census = tc.Days_to_Next_Census,
                dd.Days_to_Fall_Census = tc.Days_to_Fall_Census,
                dd.Days_to_Spring_Census = tc.Days_to_Spring_Census,
                dd.Days_to_Summer_Census = tc.Days_to_Summer_Census,                  /* 2018-05-07 DMO A */
                dd.Days_After_Census = tc.Days_After_Census,
                dd.Days_After_Last_Census = tc.Days_After_Last_Census,
                dd.Days_to_End_of_Term = tc.Days_to_End_of_Term,                      /* 2018-05-07 DMO A */
                dd.Days_to_Next_End_of_Term = tc.Days_to_Next_End_of_Term,            /* 2018-05-07 DMO A */
                dd.Days_to_Fall_End_of_Term = tc.Days_to_Fall_End_of_Term,            /* 2018-05-07 DMO A */
                dd.Days_to_Spring_End_of_Term = tc.Days_to_Spring_End_of_Term,        /* 2018-05-07 DMO A */
                dd.Days_to_Summer_End_of_Term = tc.Days_to_Summer_End_of_Term,        /* 2018-05-07 DMO A */
                /* CE Terms */
                dd.CE_Term_ID = tc.CE_Term_ID,
                dd.CE_Term_ID_Numeric = tc.CE_Term_ID_Numeric,
                dd.CE_Term_Start_Date = tc.CE_Term_Start_Date,
                dd.CE_Term_Start_Date_Key = tc.CE_Term_Start_Date_Key,
                dd.CE_Term_End_Date = tc.CE_Term_End_Date,
                dd.CE_Term_End_Date_Key = tc.CE_Term_End_Date_Key,
                dd.CE_Term_Name = tc.CE_Term_Name,
                dd.CE_Term_Description = tc.CE_Term_Description,
                dd.CE_Term_Abbreviation = tc.CE_Term_Abbreviation,
                dd.CE_Term_Type = tc.CE_Term_Type,
                dd.CE_Term_Index = tc.CE_Term_Index,
                dd.CE_Term_Sort = tc.CE_Term_Sort,
                dd.CE_Academic_Year = tc.CE_Academic_Year,
                dd.CE_Academic_Year_Start_Date = tc.CE_Academic_Year_Start_Date,
                dd.CE_Academic_Year_Start_Date_Key = tc.CE_Academic_Year_Start_Date_Key,
                dd.CE_Academic_Year_End_Date = tc.CE_Academic_Year_End_Date,
                dd.CE_Academic_Year_End_Date_Key = tc.CE_Academic_Year_End_Date_Key,
                dd.CE_Reporting_Year = tc.CE_Reporting_Year,
                dd.CE_Reporting_Academic_Year = tc.CE_Reporting_Academic_Year,
                dd.CE_Reporting_Year_FSS = tc.CE_Reporting_Year_FSS,                   /* 2019-09-12 DMO A */
                dd.CE_Reporting_Academic_Year_FSS = tc.CE_Reporting_Academic_Year_FSS, /* 2019-09-12 DMO A */
                dd.CE_Semester = tc.CE_Semester,
                dd.CE_Is_Term_Start_Date = tc.CE_Is_Term_Start_Date,
                dd.CE_Is_Term_End_Date = tc.CE_Is_Term_End_Date,
                dd.CE_Previous_Term_ID = tc.CE_Previous_Term_ID,
                dd.CE_Previous_Term_Start_Date = tc.CE_Previous_Term_Start_Date,
                dd.CE_Previous_Term_Start_Date_Key = tc.CE_Previous_Term_Start_Date_Key,
                dd.CE_Previous_Term_End_Date = tc.CE_Previous_Term_End_Date,
                dd.CE_Previous_Term_End_Date_Key = tc.CE_Previous_Term_End_Date_Key,
                dd.CE_Next_Term_ID = tc.CE_Next_Term_ID,
                dd.CE_Next_Term_Start_Date = tc.CE_Next_Term_Start_Date,
                dd.CE_Next_Term_Start_Date_Key = tc.CE_Next_Term_Start_Date_Key,
                dd.CE_Next_Term_End_Date = tc.CE_Next_Term_End_Date,
                dd.CE_Next_Term_End_Date_Key = tc.CE_Next_Term_End_Date_Key,
                dd.CE_Same_Term_ID_Last_Year = tc.CE_Same_Term_ID_Last_Year,
                dd.CE_Same_Term_ID_Next_Year = tc.CE_Same_Term_ID_Next_Year
        ;

    DROP TABLE IF EXISTS #dim
END