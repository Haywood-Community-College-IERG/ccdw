IF OBJECT_ID('dw_dim.Term_CE', 'V') IS NOT NULL
    DROP VIEW dw_dim.Term_CE
GO

CREATE VIEW dw_dim.Term_CE AS
WITH t AS (
    SELECT DISTINCT
        dd.CE_Term_ID AS Term_ID
        , dd.CE_Term_ID_Numeric AS Term_ID_Numeric
        , dd.CE_Term_Abbreviation AS Term_Abbreviation
        , dd.CE_Term_Type AS Term_Type
        , dd.CE_Term_Index AS Term_Index
        , dd.CE_Term_Sort AS Term_Sort
        , dd.CE_Term_Start_Date AS Term_Start_Date
        , dd.CE_Term_Start_Date_Key AS Term_Start_Date_Key
        , dd.CE_Term_End_Date AS Term_End_Date
        , dd.CE_Term_End_Date_Key AS Term_End_Date_Key
        , dd.CE_Term_Name AS Term_Name
        , dd.CE_Reporting_Academic_Year AS Academic_Year
        , CAST( SUBSTRING(dd.CE_Reporting_Academic_Year,1,4) + '0701' AS DATE ) AS Academic_Year_Start_Date
        , SUBSTRING(dd.CE_Reporting_Academic_Year,1,4) + '0701' AS Academic_Year_Start_Date_Key
        , CAST( SUBSTRING(dd.CE_Reporting_Academic_Year,6,4) + '0701' AS DATE ) AS Academic_Year_End_Date
        , SUBSTRING(dd.CE_Reporting_Academic_Year,6,4) + '0701' AS Academic_Year_End_Date_Key
        , dd.CE_Reporting_Academic_Year AS Reporting_Academic_Year
        , CAST( SUBSTRING(dd.CE_Reporting_Academic_Year,1,4) + '0701' AS DATE ) AS Reporting_Academic_Year_Start_Date   /* 2018-07-31 DMO A */
        , SUBSTRING(dd.CE_Reporting_Academic_Year,1,4) + '0701' AS Reporting_Academic_Year_Start_Date_Key               /* 2018-07-31 DMO A */
        , CAST( SUBSTRING(dd.CE_Reporting_Academic_Year,6,4) + '0701' AS DATE ) AS Reporting_Academic_Year_End_Date     /* 2018-07-31 DMO A */
        , SUBSTRING(dd.CE_Reporting_Academic_Year,6,4) + '0701' AS Reporting_Academic_Year_End_Date_Key                 /* 2018-07-31 DMO A */
        , dd.CE_Reporting_Academic_Year_FSS AS Reporting_Academic_Year_FSS
        , CAST( SUBSTRING(dd.CE_Reporting_Academic_Year_FSS,1,4) + '0701' AS DATE ) AS Reporting_Academic_Year_FSS_Start_Date   /* 2019-09-12 DMO A */
        , SUBSTRING(dd.CE_Reporting_Academic_Year_FSS,1,4) + '0701' AS Reporting_Academic_Year_FSS_Start_Date_Key               /* 2018-07-31 DMO A */
        , CAST( SUBSTRING(dd.CE_Reporting_Academic_Year_FSS,6,4) + '0701' AS DATE ) AS Reporting_Academic_Year_FSS_End_Date     /* 2018-07-31 DMO A */
        , SUBSTRING(dd.CE_Reporting_Academic_Year_FSS,6,4) + '0701' AS Reporting_Academic_Year_FSS_End_Date_Key                 /* 2018-07-31 DMO A */
		, dd.CE_Reporting_Academic_Year AS Fiscal_Academic_Year                                                                 /* 2018-07-31 DMO A */
        , SUBSTRING(dd.CE_Term_ID, 1, 4) AS YYYY
        , CAST(SUBSTRING(dd.CE_Term_ID, 1, 4) AS INT) AS Year_Num
		, dd.CE_Reporting_Year AS Reporting_Year                                                                        /* 2018-07-31 DMO A */
		, dd.CE_Reporting_Year_FSS AS Reporting_Year_FSS                                                                /* 2019-09-12 DMO A */
        , dd.CE_Semester AS Semester
        , CAST(NULL AS DATE) AS Term_Census_Date
        , CAST(NULL AS INT) AS Term_Census_Date_Key
        , 'N' AS Term_Census_Date_Calculated
        , dd.CE_Previous_Term_ID AS Previous_Term_ID
        , dd.CE_Previous_Term_Start_Date AS Previous_Term_Start_Date
        , dd.CE_Previous_Term_Start_Date_Key AS Previous_Term_Start_Date_Key
        , dd.CE_Previous_Term_End_Date AS Previous_Term_End_Date
        , dd.CE_Previous_Term_End_Date_Key AS Previous_Term_End_Date_Key
        , CAST(NULL AS VARCHAR) AS Previous_Regular_Term_ID
        , CAST(NULL AS VARCHAR) AS Previous_Summer_Term_ID
        , dd.CE_Next_Term_ID AS Next_Term_ID
        , dd.CE_Next_Term_Start_Date AS Next_Term_Start_Date
        , dd.CE_Next_Term_Start_Date_Key AS Next_Term_Start_Date_Key
        , dd.CE_Next_Term_End_Date AS Next_Term_End_Date
        , dd.CE_Next_Term_End_Date_Key AS Next_Term_End_Date_Key
        , CAST(NULL AS VARCHAR) AS Next_Regular_Term_ID
        , CAST(NULL AS VARCHAR) AS Next_Summer_Term_ID
        , dd.CE_Same_Term_ID_Last_Year AS Same_Term_ID_Last_Year
        , dd.CE_Same_Term_ID_Next_Year AS Same_Term_ID_Next_Year
        , SUBSTRING(dd.CE_Term_ID, 1, 4) + 
            CASE WHEN dd.CE_Term_Abbreviation = 'CE1' THEN 'SP'
                 WHEN dd.CE_Term_Abbreviation = 'CE2' THEN 'SU'
                 WHEN dd.CE_Term_Abbreviation = 'CE3' THEN 'FA'
                 ELSE NULL END AS Corresponding_Term
    FROM dw_dim.Date dd
    WHERE dd.CE_Term_ID <> 'None'
)
SELECT t.*
     , COALESCE(
            SUM(1) OVER (
                --PARTITION BY t.Term_Sort
                ORDER BY t.Term_Sort
                ROWS BETWEEN UNBOUNDED PRECEDING
                     AND     1         PRECEDING), 0) AS Term_Index_2
FROM t     