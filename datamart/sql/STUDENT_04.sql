IF OBJECT_ID('datamart.getSTUDENT_04', 'IF') IS NOT NULL
	DROP FUNCTION datamart.getSTUDENT_04
GO

CREATE FUNCTION datamart.getSTUDENT_04(
    @data_year varchar(4),
	@data_term varchar(2),
	@report_date date
)
RETURNS TABLE
AS
 RETURN
 SELECT * FROM datamart.getSTUDENT_04(@data_year, @data_term, @report_date)
 WHERE (
 SELECT DISTINCT [history].[PERSON_ST].[PERSON.ST.ID]
   FROM [history].[PERSON_ST]
  WHERE [EffectiveDatetime] <= @report_date
	AND   ([ExpirationDatetime] is null
	       OR [ExpirationDatetime] > @report_date)
 )
GO

/*

SELECT * FROM datamart.getSTUDENT_04('2018', '01', '02/23/2018')

DECLARE @data_year varchar(4) = '2018',
        @data_term varchar(2) = '01',
        @report_date date = '02/23/2018'

SELECT * FROM datamart.getSTUDENT_04(@data_year, @data_term, @report_date)

-- */