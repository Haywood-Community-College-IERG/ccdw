IF OBJECT_ID('datamart.getSTUDENT_12', 'P') IS NOT NULL
	DROP PROCEDURE datamart.getSTUDENT_12
GO

CREATE PROCEDURE datamart.getSTUDENT_12
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

WITH pst AS (
	SELECT pst.[PERSON.ST.ID]
	     --, pst.[PST.CAMPUS.ORGS.MEMBER]
		 --, pst.[PST.REGISTERED]
		 , pst.[EffectiveDatetime]
		 , pst.[ExpirationDatetime]
	FROM [history].[PERSON_ST] pst
	WHERE  pst.[EffectiveDatetime] <= @report_date
	AND   (pst.[ExpirationDatetime] is null
	OR	   [ExpirationDatetime] > @report_date)
)
	SELECT pst.[PERSON.ST.ID]
	     --, pst.[PST.CAMPUS.ORGS.MEMBER]
		 --, pst.[PST.REGISTERED]
	FROM pst
	INNER JOIN datamart.getSTUDENT_10(@data_year, @data_term, @report_date) s10 
         ON (s10.[PERSON.ST.ID] = pst.[PERSON.ST.ID]

/*
EXEC datamart.getSTUDENT_12 '2018', '01', '02/23/2018'

--, '2018SP'
*/