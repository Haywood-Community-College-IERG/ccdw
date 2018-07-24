IF OBJECT_ID('datamart.getCLASS_02', 'P') IS NOT NULL
	DROP PROCEDURE datamart.getCLASS_02
GO

CREATE PROCEDURE datamart.getCLASS_02
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

WITH sec AS (
	SELECT sec.[SEC.TERM]
	     --, sec.[SEC.SUBJECT]
		 , sec.[SEC.COURSE]
		 , sec.[SEC.NO]
		 --, sec.[SEC.SHORT.TITLE]
		 --, sec.[SEC.DEPTS]
		 , sec.[SEC.ACAD.LEVEL]
		 , sec.[SEC.COURSE.LEVELS]
		 , sec.[SEC.FUNDING.SOURCES]
		 , sec.[COURSE.SECTIONS.ADDDATE]
		 , sec.[COURSE.SECTIONS.ADDOPR]
		 , sec.[COURSE.SECTIONS.CHGDATE]
		 --, sec.[SEC.CENSUS.DATES]
		 , sec.[SEC.CONTACT.MEASURES]
		 , sec.[SEC.CONTACT.HOURS]
		 , sec.[SEC.MIN.CRED]
		 , sec.[SEC.CEUS]
		 , sec.[SEC.CAPACITY]
		 --, sec.[SEC.ACTIVE.STUDENT.COUNT]
		 --, sec.[SEC.COURSE.TYPES]
		 , sec.[SEC.CRED.TYPE]
		 /*, sec.[SEC.CURRENT.STATUS]
		 , sec.[SEC.FULL.FACULTY]
		 , sec.[SEC.LOCAL.GOVT.CODES]
		 , sec.[SEC.SYNONYM]*/
		 , sec.[SEC.USER1]
		 , sec.[XSEC.FTE]
		 , sec.[XSEC.FTE.CONTACT]
		 , sec.[XSEC.FTE.COUNT]
		 /*, sec.[SEC.FUNDING.ACCTG.METHOD]
		 , sec.[SEC.FACULTY.LAST.NAME]
		 , sec.[SEC.FACULTY.FIRST.NAME]
		 , sec.[SEC.FACULTY.MIDDLE.NAME]
		 , sec.[SEC.ALL.FACULTY]*/
		 , sec.[COURSE.SECTIONS.ID]
		 , sec.[EffectiveDatetime]
		 , sec.[ExpirationDatetime]
	FROM [history].[COURSE_SECTIONS] sec
		LEFT JOIN history.COURSE_SECTIONS__SEC_CONTACT con
			ON (con.[COURSE.SECTIONS.ID] = sec.[COURSE.SECTIONS.ID]
			AND con.[EffectiveDatetime] = sec.[EffectiveDatetime])
		LEFT JOIN history.COURSE_SECTIONS__SEC_STATUSES stat
			ON (stat.[COURSE.SECTIONS.ID] = sec.[COURSE.SECTIONS.ID]
			AND stat.[SEC.STATUS] = sec.[SEC.STATUS]
			AND stat.[EffectiveDatetime] = sec.[EffectiveDatetime]) 
	WHERE  sec.[EffectiveDatetime] <= @report_date
	AND   (sec.[ExpirationDatetime] is null
	OR	   [ExpirationDatetime] > @report_date)
)
 	SELECT sec.[SEC.TERM]
	     --, sec.[SEC.SUBJECT]
		 , sec.[SEC.COURSE]
		 , sec.[SEC.NO]
		 --, sec.[SEC.SHORT.TITLE]
		 --, sec.[SEC.DEPTS]
		 , sec.[SEC.ACAD.LEVEL]
		 , sec.[SEC.COURSE.LEVELS]
		 , sec.[SEC.FUNDING.SOURCES]
		 , sec.[COURSE.SECTIONS.ADDDATE]
		 , sec.[COURSE.SECTIONS.ADDOPR]
		 , sec.[COURSE.SECTIONS.CHGDATE]
		 --, sec.[SEC.CENSUS.DATES]
		 , sec.[SEC.CONTACT.MEASURES]
		 , sec.[SEC.CONTACT.HOURS]
		 , sec.[SEC.MIN.CRED]
		 , sec.[SEC.CEUS]
		 , sec.[SEC.CAPACITY]
		 --, sec.[SEC.ACTIVE.STUDENT.COUNT]
		 --, sec.[SEC.COURSE.TYPES]
		 , sec.[SEC.CRED.TYPE]
		 /*, sec.[SEC.CURRENT.STATUS]
		 , sec.[SEC.FULL.FACULTY]
		 , sec.[SEC.LOCAL.GOVT.CODES]
		 , sec.[SEC.SYNONYM]*/
		 , sec.[SEC.USER1]
		 , sec.[XSEC.FTE]
		 , sec.[XSEC.FTE.CONTACT]
		 , sec.[XSEC.FTE.COUNT]
		 /*, sec.[SEC.FUNDING.ACCTG.METHOD]
		 , sec.[SEC.FACULTY.LAST.NAME]
		 , sec.[SEC.FACULTY.FIRST.NAME]
		 , sec.[SEC.FACULTY.MIDDLE.NAME]
		 , sec.[SEC.ALL.FACULTY]*/
		 , sec.[COURSE.SECTIONS.ID]
	FROM sec

/*
EXEC datamart.getCLASS_02 '2018', '01', '02/23/2018'

--, '2018SP'
*/