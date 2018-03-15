IF OBJECT_ID('datamart.getSTUDENT_01', 'IF') IS NOT NULL
	DROP FUNCTION datamart.getSTUDENT_01
GO

CREATE FUNCTION datamart.getSTUDENT_01(
    @data_year varchar(4),
	@data_term varchar(2),
	@report_date date
)
RETURNS TABLE
AS
 RETURN
 SELECT DISTINCT [history].[STUDENT_TERMS].[STTR.STUDENT]
   FROM [history].[STUDENT_TERMS]
  WHERE [STTR.TERM] IN (
        @data_year + CASE WHEN @data_term = '01' THEN 'CE1'
                            WHEN @data_term = '02' THEN 'CE2'
                            WHEN @data_term = '03' THEN 'CE3'
                            ELSE 'XX' END, 
        @data_year + CASE WHEN @data_term = '01' THEN 'SP'
                            WHEN @data_term = '02' THEN 'SU'
                            WHEN @data_term = '03' THEN 'FA'
                            ELSE 'XX' END
        )
    --AND    [EffectiveDatetime] <= @report_date
	--AND   ([ExpirationDatetime] is null
	--OR	   [ExpirationDatetime] > @report_date)
GO

/*

SELECT * FROM datamart.getSTUDENT_01('2018', '01', '02/23/2018')

DECLARE @data_year varchar(4) = '2018',
        @data_term varchar(2) = '01',
        @report_date date = '02/23/2018'

SELECT * FROM datamart.getSTUDENT_01(@data_year, @data_term, @report_date)

-- */