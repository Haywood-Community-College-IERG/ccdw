IF OBJECT_ID('datamart.getSTUDENT_01', 'P') IS NOT NULL
	DROP FUNCTION datamart.getSTUDENT_01
GO

CREATE FUNCTION datamart.getSTUDENT_01(@StudentID int)
RETURNS @STUDENT_TERMS TABLE
(	
	[STTR.STUDENT] varchar(10) PRIMARY KEY NOT NULL,
	[STTR.TERM] varchar(7) NOT NULL
)
AS

BEGIN
	DECLARE
		@STTRTERM varchar(7),
		@STTRSTUDENT varchar(10),
		@data_year varchar(4),
		@data_term varchar(2),
		@report_date date,
		@term_id_ce varchar(20),
		@term_id_cu varchar(20)

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

	PRINT @term_id_ce;
	PRINT @term_id_cu;

AS SELECT @STTRSTUDENT,
		   @STTRTERM
	FROM [history].[STUDENT_TERMS]
	WHERE [STTR.TERM] IN (@term_id_ce, @term_id_cu)
    AND    [EffectiveDatetime] <= @report_date
	AND   ([ExpirationDatetime] is null
	OR	   [ExpirationDatetime] > @report_date)
)
END;