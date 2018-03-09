IF OBJECT_ID('datamart.getGRADUATION', 'P') IS NOT NULL
    DROP PROCEDURE datamart.getGRADUATION
GO

CREATE PROCEDURE datamart.getGRADUATION
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

WITH cred AS (
    SELECT	[ACAD.PERSON.ID]
           ,[ACAD.TRANSCRIPT.ADDRESS]
           ,[ACAD.TRANSCRIPT.CITY]
           ,[ACAD.TRANSCRIPT.STATE]
           ,[ACAD.TRANSCRIPT.ZIP]
           ,[ACAD.TRANSCRIPT.COUNTRY]
           ,[ACAD.TERM]
           ,[ACAD.ACAD.PROGRAM]
    FROM	[IERG].[history].[ACAD_CREDENTIALS]
    WHERE	[EffectiveDatetime] <= @report_date
    AND	   ([ExpirationDatetime] is null
            OR [ExpirationDatetime] > @report_date)

), person AS (
    SELECT  [FIRST.NAME]
           ,[MIDDLE.NAME]
           ,[LAST.NAME]
           ,[ID]
    FROM	[IERG].[history].[PERSON]
    WHERE	[EffectiveDatetime] <= @report_date
    AND	   ([ExpirationDatetime] is null
            OR [ExpirationDatetime] > @report_date)

), prog AS (
    SELECT  [ACPG.CIP]
           ,[ACAD.PROGRAMS.ID]
    FROM	[IERG].[history].[ACAD_PROGRAMS]
    WHERE	[EffectiveDatetime] <= @report_date
    AND	   ([ExpirationDatetime] is null
            OR [ExpirationDatetime] > @report_date)
)
    SELECT  cred.[ACAD.PERSON.ID]
           ,cred.[ACAD.TRANSCRIPT.ADDRESS]
           ,cred.[ACAD.TRANSCRIPT.CITY]
           ,cred.[ACAD.TRANSCRIPT.STATE]
           ,cred.[ACAD.TRANSCRIPT.ZIP]
           ,cred.[ACAD.TRANSCRIPT.COUNTRY]
           ,cred.[ACAD.TERM]
           ,cred.[ACAD.ACAD.PROGRAM]
           ,person.[FIRST.NAME]
           ,person.[MIDDLE.NAME]
           ,person.[LAST.NAME]
           ,prog.[ACPG.CIP]
    FROM	cred
        LEFT JOIN person ON (person.[ID] = cred.[ACAD.PERSON.ID])
        LEFT JOIN prog	 ON (prog.[ACAD.PROGRAMS.ID] = cred.[ACAD.ACAD.PROGRAM])
    WHERE cred.[ACAD.TERM] IN (@term_id_ce, @term_id_cu)

/* 

EXEC datamart.getGRADUATION '2013', '03', '12/23/2017'
EXEC datamart.getGRADUATION '2013', '03', '02/23/2018'

*/