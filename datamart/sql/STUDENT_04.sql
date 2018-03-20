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
	SELECT [PERSON.ST.ID]
	FROM [history].[PERSON_ST]
	INNER JOIN datamart.getSTUDENT_01(@data_year, @data_term, @report_date)
		ON (getSTUDENT_01.[STTR.STUDENT] = [PERSON.ST.ID])
GO

/*

SELECT * FROM datamart.getSTUDENT_04('2018', '01', '02/23/2018')

DECLARE @data_year varchar(4) = '2018',
        @data_term varchar(2) = '01',
        @report_date date = '02/23/2018'

SELECT * FROM datamart.getSTUDENT_04(@data_year, @data_term, @report_date)

-- */