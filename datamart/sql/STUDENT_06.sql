IF OBJECT_ID('datamart.getSTUDENT_06', 'IF') IS NOT NULL
	DROP FUNCTION datamart.getSTUDENT_06
GO

CREATE FUNCTION datamart.getSTUDENT_06(
    @data_year varchar(4),
	@data_term varchar(2),
	@report_date date
)
RETURNS TABLE
AS
 RETURN
 SELECT [INSTA.INSTITUTIONS.ID]
       ,[INSTA.PERSON.ID]
 FROM history.INSTITUTIONS_ATTEND
 INNER JOIN datamart.getSTUDENT_01(@data_year, @data_term, @report_date) s01
       ON (s01.[STTR.STUDENT] = [INSTA.PERSON.ID])
 WHERE [EffectiveDatetime] <= @report_date
   AND   ([ExpirationDatetime] is null
   OR [ExpirationDatetime] > @report_date)
GO

/*

SELECT * FROM datamart.getSTUDENT_06('2018', '01', '02/23/2018')

DECLARE @data_year varchar(4) = '2018',
        @data_term varchar(2) = '01',
        @report_date date = '02/23/2018'

SELECT * FROM datamart.getSTUDENT_06(@data_year, @data_term, @report_date)

-- */