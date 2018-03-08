IF OBJECT_ID('datamart.getSTUDENT_03', 'P') IS NOT NULL
	DROP PROCEDURE datamart.getSTUDENT_03
GO

CREATE PROCEDURE datamart.getSTUDENT_03
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

WITH xnc AS (
	SELECT [XNC.PERSON.ID]
		  ,[XNC.INMATE.FLAG]
		  ,[XNC.ECON.DISADVANTAGED.FLAG]
	      ,[XNC.SINGLE.PARENT.FLAG]
	      ,[XNC.HEAD.HOUSEHOLD.FLAG]
	      ,[XNC.LIMITED.ENGLISH.FLAG]
	      ,[XNC.HIGH.SCHOOL.TRACK]
	      ,[XNC.EDU.ENTRY.LEVEL]
	      ,[XNC.FATHER.DEGREE.FLAG]
	      ,[XNC.MOTHER.DEGREE.FLAG]
	      ,[XNC_PERSON].[EffectiveDatetime]
	      ,[XNC_PERSON].[ExpirationDatetime]
	FROM   [IERG].[history].[XNC_PERSON]
	WHERE  [EffectiveDatetime] <= @report_date
	AND   ([ExpirationDatetime] is null
	OR	   [ExpirationDatetime] > @report_date)

), trm AS (
	SELECT  [ACAD.TERM]
		   ,[ACAD.PERSON.ID]
	FROM	[IERG].[history].[ACAD_CREDENTIALS]
	WHERE	[EffectiveDatetime] <= @report_date
	AND	   ([ExpirationDatetime] is null
	OR		[ExpirationDatetime] > @report_date)
	)

	SELECT	xnc.[XNC.PERSON.ID]
		   ,xnc.[XNC.INMATE.FLAG]
		   ,xnc.[XNC.ECON.DISADVANTAGED.FLAG]
	       ,xnc.[XNC.SINGLE.PARENT.FLAG]
	       ,xnc.[XNC.HEAD.HOUSEHOLD.FLAG]
	       ,xnc.[XNC.LIMITED.ENGLISH.FLAG]
	       ,xnc.[XNC.HIGH.SCHOOL.TRACK]
	       ,xnc.[XNC.EDU.ENTRY.LEVEL]
	       ,xnc.[XNC.FATHER.DEGREE.FLAG]
	       ,xnc.[XNC.MOTHER.DEGREE.FLAG]
	FROM xnc 
		LEFT JOIN trm ON (trm.[ACAD.PERSON.ID] = xnc.[XNC.PERSON.ID])
	WHERE trm.[ACAD.TERM] IN (@term_id_ce, @term_id_cu)