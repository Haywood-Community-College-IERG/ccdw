IF OBJECT_ID('dw_dim.Term_CU_Current', 'V') IS NOT NULL
    DROP VIEW dw_dim.Term_CU_Current
GO

CREATE VIEW dw_dim.Term_CU_Current AS 
SELECT *
  FROM dw_dim.Term_CU t
 WHERE t.Term_Start_Date <= GETDATE()
   AND t.Term_End_Date >= GETDATE()
