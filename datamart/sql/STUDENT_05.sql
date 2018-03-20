IF OBJECT_ID('datamart.getSTUDENT_05', 'P') IS NOT NULL
	DROP PROCEDURE datamart.getSTUDENT_05
GO

CREATE PROCEDURE datamart.getSTUDENT_05
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

WITH nctype AS (
	SELECT [NCRS.TYPE]
		  ,[NON.COURSES.ID]
		  ,[EffectiveDatetime]
	FROM   [history].[NON_COURSES]
	
), stnc AS (
	SELECT [STUDENT.NON.COURSES.ID]
		  ,[NCRS.TYPE]
		  ,[STNC.PERSON.ID]
		  ,[STNC.SOURCE]
	      ,[STNC.CATEGORY]
	      --,[STNC.CATEGORY.TRANSLATION]
	      ,[STNC.START.DATE]
	      ,[STNC.END.DATE]
	      ,[STNC.STATUS]
	      --,[STNC.STATUS.DATE]
	      ,[STNC.NON.COURSE]
	      ,[STNC.TITLE]
	      ,[STNC.SCORE]
		  ,stnc.[EffectiveDatetime]
		  ,[ExpirationDatetime]
	FROM [history].[STUDENT_NON_COURSES] stnc
		LEFT JOIN nctype
			ON ([NON.COURSES.ID] = [STUDENT.NON.COURSES.ID]
				AND nctype.[EffectiveDateTime] = stnc.[EffectiveDatetime])
	WHERE  stnc.[EffectiveDatetime] <= @report_date
	AND   (stnc.[ExpirationDatetime] is null
	OR	   [ExpirationDatetime] > @report_date)

), trm AS (
	SELECT  DISTINCT
            [STTR.TERM]
		   ,[STTR.STUDENT]
	FROM	[history].[STUDENT_TERMS]
    WHERE [STTR.TERM] IN (@term_id_ce, @term_id_cu)
    --AND    [EffectiveDatetime] <= @report_date
	--AND   ([ExpirationDatetime] is null
	--OR	   [ExpirationDatetime] > @report_date)
)

SELECT stnc.[STUDENT.NON.COURSES.ID]
	  ,stnc.[STNC.PERSON.ID]
	  ,stnc.[STNC.SOURCE]
	  ,stnc.[STNC.CATEGORY]
	  --,stnc.[STNC.CATEGORY.TRANSLATION]
	  ,stnc.[STNC.START.DATE]
	  ,stnc.[STNC.END.DATE]
	  ,stnc.[STNC.STATUS]
	  --,stnc.[STNC.STATUS.DATE]
	  ,stnc.[STNC.NON.COURSE]
	  ,stnc.[STNC.TITLE]
	  ,stnc.[STNC.SCORE]
	  ,nctype.[NCRS.TYPE]
FROM  nctype, stnc
	INNER JOIN trm ON (trm.[STTR.STUDENT] = stnc.[STNC.PERSON.ID])

/*
EXEC datamart.getSTUDENT_03 '2018', '01', '02/23/2018'

--, '2018SP'
*/