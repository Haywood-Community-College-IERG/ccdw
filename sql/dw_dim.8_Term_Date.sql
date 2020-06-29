IF OBJECT_ID('dw_dim.Term_Date', 'V') IS NOT NULL
    DROP VIEW dw_dim.Term_Date
GO

CREATE VIEW dw_dim.Term_Date AS
SELECT CAST(t.Term_Index AS bigint)*100000000 + d.Date_Key AS Date_Term_Key            /* 2018-07-17 DMO C - Swap term and date, fix multiplyer */
     , DATEDIFF( dd, d.Full_Date, t.Term_Start_Date ) AS Days_to_Term_Start_Date
     , d.*
  FROM dw_dim.Date d
  LEFT JOIN dw_dim.Term_CU t
       ON (d.Full_Date >= DATEADD( dd, -365, t.Term_Start_Date)
	       AND d.Full_Date <= t.Term_End_Date )
WHERE t.Term_Sort IS NOT NULL
