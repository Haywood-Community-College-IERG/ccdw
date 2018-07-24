IF OBJECT_ID('datamart.getSTUDENT_11', 'P') IS NOT NULL
	DROP PROCEDURE datamart.getSTUDENT_11
GO

CREATE PROCEDURE datamart.getSTUDENT_11
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

WITH sal AS (
	SELECT sal.[STA.STUDENT]
		 , sal.[STA.ACAD.LEVEL]
		 , sal.[STA.ADMIT.STATUS]
		 , sal.[STA.FED.COHORT.GROUP]
		 , sal.[STA.START.TERM]
		 , brows.[STA.TERMS]
		 /*, sal.[STA.ATTEMPT.CREDS]
		 , sal.[STA.CMPL.CRED]
		 , sal.[STA.CUM.GPA]
		 , sal.[X.STA.PROGRAM.GPA]*/
		 , sal.[EffectiveDatetime]
		 , sal.[ExpirationDatetime]
	FROM [history].[STUDENT_ACAD_LEVELS] sal
		LEFT JOIN history.STUDENT_ACAD_LEVELS_Current brows
			ON (brows.[STA.ACAD.LEVEL] = sal.[STA.ACAD.LEVEL]
				AND brows.[STA.STUDENT] = sal.[STA.STUDENT]
				AND brows.[EffectiveDatetime] = sal.[EffectiveDatetime])
	WHERE  sal.[EffectiveDatetime] <= @report_date
	AND   (sal.[ExpirationDatetime] is null
	OR	   sal.[ExpirationDatetime] > @report_date)
) 
	SELECT sal.[STA.STUDENT]
		 , sal.[STA.ACAD.LEVEL]
		 , sal.[STA.ADMIT.STATUS]
		 , sal.[STA.FED.COHORT.GROUP]
		 , sal.[STA.START.TERM]
		 , sal.[STA.TERMS]
		 /*, sal.[STA.ATTEMPT.CREDS]
		 , sal.[STA.CMPL.CRED]
		 , sal.[STA.CUM.GPA]
		 , sal.[X.STA.PROGRAM.GPA]*/
	FROM sal
	/*INNER JOIN datamart.getSTUDENT_10(@data_year, @data_term, @report_date) s10 
         ON ()*/
;

/*
EXEC datamart.getSTUDENT_11 '2018', '01', '02/23/2018'

--, '2018SP'
*/