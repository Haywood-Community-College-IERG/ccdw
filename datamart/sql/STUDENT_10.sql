IF OBJECT_ID('datamart.getSTUDENT_10', 'IF') IS NOT NULL
	DROP FUNCTION datamart.getSTUDENT_10
GO

CREATE FUNCTION datamart.getSTUDENT_10(
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