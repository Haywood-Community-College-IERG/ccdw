USE CCDW_HIST
GO 

IF OBJECT_ID (N'dw_util.GetEasterHolidays', N'IF') IS NOT NULL  
-- deletes function  
    DROP FUNCTION dw_util.GetEasterHolidays;  
GO 

CREATE OR ALTER FUNCTION dw_util.GetEasterHolidays(@year INT) 
RETURNS TABLE
WITH SCHEMABINDING
AS 
RETURN 
(
  WITH x AS 
  (
    SELECT Full_Date = CONVERT(DATE, RTRIM(@year) + '0' + RTRIM([Month]) 
        + RIGHT('0' + RTRIM([Day]),2))
      FROM (SELECT [Month], [Day] = DaysToSunday + 28 - (31 * ([Month] / 4))
              FROM (SELECT [Month] = 3 + (DaysToSunday + 40) / 44, DaysToSunday
                      FROM (SELECT DaysToSunday = paschal - ((@year + @year / 4 + paschal - 13) % 7)
                              FROM (SELECT paschal = epact - (epact / 28)
                                      FROM (SELECT epact = (24 + 19 * (@year % 19)) % 30) AS epact) AS paschal) AS dts) AS m) AS d
  )
  SELECT Full_Date, Holiday_Name = 'Easter Sunday' FROM x
    UNION ALL SELECT DATEADD(DAY,-2,Full_Date), 'Good Friday'   FROM x
    UNION ALL SELECT DATEADD(DAY, 1,Full_Date), 'Easter Monday' FROM x
);