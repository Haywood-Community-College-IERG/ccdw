IF OBJECT_ID('datamart.getSTUDENT_09', 'P') IS NOT NULL
	DROP PROCEDURE datamart.getSTUDENT_09
GO

CREATE PROCEDURE datamart.getSTUDENT_09
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

WITH stc AS (
	SELECT stc.[STC.PERSON.ID]
		 /*, stc.[STC.COURSE.NAME]
		 , stc.[STC.SECTION.NO]
		 , stc.[STC.SUBJECT]
		 , stc.[STC.TERM]
		 , stc.[STC.REPORTING.TERM]
		 , stc.[STC.STATUS]
		 , stc.[STC.STATUS.DATE]
		 , stc.[STC.STATUS.TIME]
		 , stc.[STC.STATUS.REASON]
		 , stc.[STC.GRADE.SCHEME]
		 , stc.[STC.CEUS]
		 , stc.[STC.GRED]
		 , stc.[STC.FINAL]
		 , stc.[X.SCS.GRADE]
		 , stc.[X.SCS.GRADE.DESC]
		 , stc.[STC.VERIFIED.GRADE]
		 , stc.[STC.VERIFIED.GRADE.CHGOPR]
		 , stc.[STC.VERIFIED.GRADE.DATE]*/
		 , stc.[SCS.REG.METHOD]
		 --, stc.[X.SCS.SEC.COURSE.NO]
	FROM [history].[STUDENT_COURSE_SEC] stc
)
