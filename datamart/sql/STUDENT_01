IF OBJECT_ID('datamart.getSTUDENT_01', 'P') IS NOT NULL
	DROP PROCEDURE datamart.getSTUDENT_01
GO

CREATE PROCEDURE datamart.getSTUDENT_01
	@data_year varchar(4),
	@data_term varchar(2),
	@report_date date
AS
	DECLARE @term_id_ce varchar(20)
	DECLARE @term_id_cu varchar(20)

	IF @data_term = '01'
		BEGIN
			SET @term_id_ce = @data_year + 'CE1'
			SET @term_id_cu = @data_year + 'SP'
		END
	ELSE BEGIN
		IF @data_term = '02'
			BEGIN
				SET @term_id_ce = @data_year + 'CE2'
				SET @term_id_cu = @data_year + 'SU'
			END
		ELSE
			BEGIN
				SET @term_id_ce = @data_year + 'CE3'
				SET @term_id_cu = @data_year + 'FA'
			END
	END;

	PRINT @term_id_ce;
	PRINT @term_id_cu;

SELECT  DISTINCT
            [STTR.TERM]
		   ,[STTR.STUDENT]
	FROM	[history].[STUDENT_TERMS]
    WHERE [STTR.TERM] IN (@term_id_ce, @term_id_cu)
    AND    [EffectiveDatetime] <= @report_date
	AND   ([ExpirationDatetime] is null
	OR	   [ExpirationDatetime] > @report_date)

/*
EXEC datamart.getSTUDENT_01 '2018', '01', '02/23/2018'

--, '2018SP'
*/