IF OBJECT_ID('datamart.getSTUDENT_14', 'P') IS NOT NULL
	DROP PROCEDURE datamart.getSTUDENT_14
GO

CREATE PROCEDURE datamart.getSTUDENT_14
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

WITH stpr AS (
	SELECT stpr.[STPR.STUDENT]
		 --, stpr.[STPR.ACAD.LEVEL]
		 , stpr.[STPR.ACAD.PROGRAM]
		 , stpr.[STPR.USER1]
		 --, stpr.[STPR.ACTUAL.TITLE]
		 , stpr.[STPR.ADMIT.STATUS]
		 --, stpr.[STPR.ALLOW.GRADUATION.FLAG]
		 , stpr.[STPR.CATALOG]
		 --, stpr.[STPR.CURRENT.END.DATE]
		 --, stpr.[STPR.CURRENT.STATUS]
		 --, stpr.[STPR.CURRENT.STATUS.DATE]
		 , stpr.[STPR.END.DATE]
		 , stpr.[STPR.START.DATE]
		 , stpr.[STPR.STATUS]
		 , stpr.[STPR.STATUS.CHGOPR]
		 , stpr.[STPR.STATUS.DATE]
		 , stpr.[STPR.STUDENT.ED.PLAN]
		 , stpr.[STPR.DEPT]
		 , stpr.[EffectiveDatetime]
		 , stpr.[ExpirationDatetime]
	FROM [history].[STUDENT_PROGRAMS] stpr
		LEFT JOIN history.STUDENT_PROGRAMS__STPR_DATES adate
			ON (adate.[STPR.STUDENT] = stpr.[STPR.STUDENT]
			AND adate.[STPR.ACAD.PROGRAM] = stpr.[STPR.ACAD.PROGRAM]
			AND adate.[EffectiveDatetime] = stpr.[EffectiveDatetime])
		LEFT JOIN history.STUDENT_PROGRAMS__STPR_STATUSES stat
			ON (stat.[STPR.STUDENT] = stpr.[STPR.STUDENT]
			AND stat.[STPR.ACAD.PROGRAM] = stpr.[STPR.ACAD.PROGRAM]
			AND stat.[EffectiveDatetime] = stpr.[EffectiveDatetime])
	WHERE  stpr.[EffectiveDatetime] <= @report_date
	AND   (stpr.[ExpirationDatetime] is null
	OR	   [ExpirationDatetime] > @report_date)
)
SELECT stpr.[STPR.STUDENT]
		 --, stpr.[STPR.ACAD.LEVEL]
		 , stpr.[STPR.ACAD.PROGRAM]
		 , stpr.[STPR.USER1]
		 --, stpr.[STPR.ACTUAL.TITLE]
		 , stpr.[STPR.ADMIT.STATUS]
		 --, stpr.[STPR.ALLOW.GRADUATION.FLAG]
		 , stpr.[STPR.CATALOG]
		 --, stpr.[STPR.CURRENT.END.DATE]
		 --, stpr.[STPR.CURRENT.STATUS]
		 --, stpr.[STPR.CURRENT.STATUS.DATE]
		 , stpr.[STPR.END.DATE]
		 , stpr.[STPR.START.DATE]
		 , stpr.[STPR.STATUS]
		 , stpr.[STPR.STATUS.CHGOPR]
		 , stpr.[STPR.STATUS.DATE]
		 , stpr.[STPR.STUDENT.ED.PLAN]
		 , stpr.[STPR.DEPT]
	FROM stpr
	/*INNER JOIN datamart.getSTUDENT_13(@data_year, @data_term, @report_date) s13 
         ON (s13.[PERSON.ST.ID] = stpr.[STPR.STUDENT]*/

/*
EXEC datamart.getSTUDENT_14 '2018', '01', '02/23/2018'

--, '2018SP'
*/