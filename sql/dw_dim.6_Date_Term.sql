IF OBJECT_ID('dw_dim.Date_Term', 'V') IS NOT NULL
    DROP VIEW dw_dim.Date_Term
GO

CREATE VIEW dw_dim.Date_Term AS
SELECT CAST(d.Date_Key AS bigint)*100000 + t.Term_Index AS Date_Term_Key
     , DATEDIFF( dd, d.Full_Date, t.Term_Start_Date ) AS Days_to_Term_Start_Date
     , d.*
  FROM dw_dim.Date d
  LEFT JOIN dw_dim.Term_CU t
       ON (d.Full_Date >= DATEADD( dd, -365, t.Term_Start_Date)
	       AND d.Full_Date <= t.Term_End_Date )
WHERE t.Term_Sort IS NOT NULL
