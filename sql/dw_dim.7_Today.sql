CREATE VIEW dw_dim.Today AS 
    SELECT *
      FROM dw_dim.Date d
     WHERE d.Full_Date = CAST(GETDATE() AS DATE)
;