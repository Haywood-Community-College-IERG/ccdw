IF OBJECT_ID('datamart.getSTUDENT_07', 'P') IS NOT NULL
	DROP PROCEDURE datamart.getSTUDENT_07
GO

CREATE PROCEDURE datamart.getSTUDENT_07
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

WITH insta AS (
	SELECT insta.[INSTA.PERSON.ID]
		  ,insta.[INSTA.INSTITUTIONS.ID]
		  ,insta.[X.INSTA.INSTITUTION]
		  ,adate.[INSTA.START.DATES]
		  ,adate.[INSTA.END.DATES]
		  ,insta.[INSTA.GRAD.TYPE]
		  ,tdate.[INSTA.TRANSCRIPT.TYPE]
		  ,tdate.[INSTA.TRANSCRIPT.DATE]
		  ,tdate.[INSTA.TRANSCRIPT.STATUS]
		  ,insta.[INSTA.INST.TYPE]
		  --,.insta.[INSTA.PE]
		  ,insta.[EffectiveDatetime]
		  ,[ExpirationDateTime]
	FROM [history].[INSTITUTIONS_ATTEND] insta
		LEFT JOIN history.INSTITUTIONS_ATTEND__DATES_ATTENDED adate
			ON (adate.[INSTA.INSTITUTIONS.ID] = insta.[INSTA.INSTITUTIONS.ID]
                AND adate.[INSTA.PERSON.ID] = insta.[INSTA.PERSON.ID]
				AND adate.[EffectiveDatetime] = insta.[EffectiveDatetime])
		LEFT JOIN history.INSTITUTIONS_ATTEND__TRANSCRIPT tdate
			ON (tdate.[INSTA.INSTITUTIONS.ID] = insta.[INSTA.INSTITUTIONS.ID]
                AND tdate.[INSTA.PERSON.ID] = insta.[INSTA.PERSON.ID]
				AND tdate.[EffectiveDatetime] = insta.[EffectiveDatetime])
	WHERE  insta.[EffectiveDatetime] <= @report_date
	AND   (insta.[ExpirationDatetime] is null
	OR	   [ExpirationDatetime] > @report_date)
)
	SELECT insta.[INSTA.PERSON.ID]
		  ,insta.[INSTA.INSTITUTIONS.ID]
		  ,insta.[X.INSTA.INSTITUTION]
		  ,insta.[INSTA.START.DATES]
		  ,insta.[INSTA.END.DATES]
		  ,insta.[INSTA.GRAD.TYPE]
		  ,insta.[INSTA.TRANSCRIPT.TYPE]
		  ,insta.[INSTA.TRANSCRIPT.DATE]
		  ,insta.[INSTA.TRANSCRIPT.STATUS]
		  ,insta.[INSTA.INST.TYPE]
		  --,insta.[INSTA.PE]
	FROM insta
   INNER JOIN datamart.getSTUDENT_06(@data_year, @data_term, @report_date) s06 
         ON (s06.[INSTA.INSTITUTIONS.ID] = insta.[INSTA.INSTITUTIONS.ID]
             AND s06.[INSTA.PERSON.ID] = insta.[INSTA.PERSON.ID])
;

/*
EXEC datamart.getSTUDENT_07 '2018', '01', '02/23/2018'

--, '2018SP'
*/