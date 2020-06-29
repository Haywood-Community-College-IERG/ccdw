IF OBJECT_ID('dw_dim.Term_CU', 'V') IS NOT NULL
    DROP VIEW dw_dim.Term_CU
GO

CREATE VIEW dw_dim.Term_CU AS
WITH t AS (
    SELECT DISTINCT
           dd.Term_ID
         , dd.Term_ID_Numeric
         , dd.Term_Abbreviation
         , dd.Term_Type
         , dd.Term_Index
         , dd.Term_Sort
         , dd.Term_Start_Date
         , dd.Term_Start_Date_Key
         , dd.Term_End_Date
         , dd.Term_End_Date_Key
         , dd.Term_Name
         , dd.Academic_Year
         , CAST( SUBSTRING(dd.Academic_Year,1,4) + '0701' AS DATE ) AS Academic_Year_Start_Date
         , SUBSTRING(dd.Academic_Year,1,4) + '0701' AS Academic_Year_Start_Date_Key
         , CAST( SUBSTRING(dd.Academic_Year,6,4) + '0701' AS DATE ) AS Academic_Year_End_Date
         , SUBSTRING(dd.Academic_Year,6,4) + '0701' AS Academic_Year_End_Date_Key
         , dd.Reporting_Academic_Year                                                                                /* 2018-07-31 DMO A */
         , CAST( SUBSTRING(dd.Reporting_Academic_Year,1,4) + '0701' AS DATE ) AS Reporting_Academic_Year_Start_Date  /* 2018-07-31 DMO A */
         , SUBSTRING(dd.Reporting_Academic_Year,1,4) + '0701' AS Reporting_Academic_Year_Start_Date_Key              /* 2018-07-31 DMO A */
         , CAST( SUBSTRING(dd.Reporting_Academic_Year,6,4) + '0701' AS DATE ) AS Reporting_Academic_Year_End_Date    /* 2018-07-31 DMO A */
         , SUBSTRING(dd.Reporting_Academic_Year,6,4) + '0701' AS Reporting_Academic_Year_End_Date_Key                /* 2018-07-31 DMO A */
         , dd.Reporting_Academic_Year_FSS                                                                            /* 2019-09-12 DMO A */
         , CAST( SUBSTRING(dd.Reporting_Academic_Year_FSS,1,4) + '0701' AS DATE ) AS Reporting_Academic_Year_FSS_Start_Date  /* 2019-09-12 DMO A */
         , SUBSTRING(dd.Reporting_Academic_Year_FSS,1,4) + '0701' AS Reporting_Academic_Year_FSS_Start_Date_Key              /* 2019-09-12 DMO A */
         , CAST( SUBSTRING(dd.Reporting_Academic_Year_FSS,6,4) + '0701' AS DATE ) AS Reporting_Academic_Year_FSS_End_Date    /* 2019-09-12 DMO A */
         , SUBSTRING(dd.Reporting_Academic_Year_FSS,6,4) + '0701' AS Reporting_Academic_Year_FSS_End_Date_Key                /* 2019-09-12 DMO A */
         , dd.Fiscal_Academic_Year   /* 2018-06-04 DMO A */
         , CASE WHEN dd.Term_Abbreviation = 'WI' THEN dd.Reporting_Year
                ELSE dd.YYYY END AS YYYY
         , CASE WHEN dd.Term_Abbreviation = 'WI' THEN CAST(dd.Reporting_Year AS INT)
                ELSE dd.Year_Num END AS Year_Num
		 , dd.Reporting_Year                                                                                         /* 2018-07-31 DMO A */
		 , dd.Reporting_Year_FSS                                                                                     /* 2019-09-12 DMO A */
         , dd.Semester
         , census.Term_Census_Date
         , census.Term_Census_Date_Key
         , census.Term_Census_Date_Calculated
         , dd.Previous_Term_ID
         , dd.Previous_Term_Start_Date
         , dd.Previous_Term_Start_Date_Key
         , dd.Previous_Term_End_Date
         , dd.Previous_Term_End_Date_Key
         , dd.Previous_Regular_Term_ID
         , dd.Previous_Summer_Term_ID
         , dd.Next_Term_ID
         , dd.Next_Term_Start_Date
         , dd.Next_Term_Start_Date_Key
         , dd.Next_Term_End_Date
         , dd.Next_Term_End_Date_Key
         , dd.Next_Regular_Term_ID
         , dd.Next_Summer_Term_ID
         , dd.Same_Term_ID_Last_Year
         , dd.Same_Term_ID_Next_Year
        , SUBSTRING(dd.Term_ID, 1, 4) + 
            CASE WHEN dd.Term_Abbreviation = 'SP' THEN 'CE1'
                 WHEN dd.Term_Abbreviation = 'SU' THEN 'CE2'
                 WHEN dd.Term_Abbreviation = 'FA' THEN 'CE3'
                 ELSE NULL END AS Corresponding_Term
      FROM dw_dim.Date dd
      LEFT JOIN (SELECT DISTINCT 
                        ddc.Term_ID
                      , ddc.Full_Date AS Term_Census_Date
                      , ddc.Date_Key AS Term_Census_Date_Key
                      , ddc.Term_Census_Calculated AS Term_Census_Date_Calculated
                   FROM dw_dim.Date ddc
                  WHERE [Is_Term_Census_Date] = 'Y') census
           ON (census.Term_ID = dd.Term_ID)
     WHERE dd.Term_ID <> 'None'
)
SELECT t.*
     , COALESCE(
            SUM(1) OVER (
                --PARTITION BY t.Term_Sort
                ORDER BY t.Term_Sort
                ROWS BETWEEN UNBOUNDED PRECEDING
                     AND     1         PRECEDING), 0) AS Term_Index_2
FROM t     