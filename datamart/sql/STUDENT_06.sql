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
	 SELECT [INSTA.PERSON.ID]
	 FROM [history].[INSTITUTIONS_ATTEND]
	 INNER JOIN datamart.getSTUDENT_04(@data_year, @data_term, @report_date)
		ON (getSTUDENT_04.[PERSON.ST.ID] = [INSTA.PERSON.ID])
GO

/*

SELECT * FROM datamart.getSTUDENT_06('2018', '01', '02/23/2018')

DECLARE @data_year varchar(4) = '2018',
        @data_term varchar(2) = '01',
        @report_date date = '02/23/2018'

SELECT * FROM datamart.getSTUDENT_06(@data_year, @data_term, @report_date)

-- */