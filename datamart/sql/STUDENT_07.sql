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

WITH adate AS (
	SELECT [INSTA.PERSON.ID]
		  ,CAST(LTRIM(RTRIM(CA1.Item)) AS DATE) AS [INSTA.START.DATES]
          ,CA1.ItemNumber AS ItemNumber
		  ,CAST(LTRIM(RTRIM(CA2.Item)) AS DATE) AS [INSTA.END.DATES]
		  ,CA2.ItemNumber AS ItemNumber2
          ,EffectiveDatetime
      FROM [history].[INSTITUTIONS_ATTEND]
     CROSS APPLY dbo.DelimitedSplit8K([INSTA.START.DATES], ', ') CA1
	 CROSS APPLY dbo.DelimitedSplit8K([INSTA.END.DATES], ', ') CA2
     WHERE COALESCE([INSTA.START.DATES], '') != '' 
	 AND   COALESCE([INSTA.END.DATES], '') != ''

), tdate AS (
	SELECT [INSTA.PERSON.ID]
		  ,CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(20)) AS [INSTA.TRANSCRIPT.TYPE]
          ,CA1.ItemNumber AS ItemNumber
		  ,CAST(LTRIM(RTRIM(CA2.Item)) AS DATE) AS [INSTA.TRANSCRIPT.DATE]
		  ,CA2.ItemNumber AS ItemNumber2
		  ,CAST(LTRIM(RTRIM(CA2.Item)) as VARCHAR(28)) AS [INSTA.TRANSCRIPT.STATUS]
		  ,CA3.ItemNumber as ItemNumber3
          ,EffectiveDatetime
      FROM [history].[INSTITUTIONS_ATTEND]
     CROSS APPLY dbo.DelimitedSplit8K([INSTA.TRANSCRIPT.TYPE], ', ') CA1
	 CROSS APPLY dbo.DelimitedSplit8K([INSTA.TRANSCRIPT.DATE], ', ') CA2
	 CROSS APPLY dbo.DelimitedSplit8K([INSTA.TRANSCRIPT.STATUS], ', ') CA3
     WHERE COALESCE([INSTA.TRANSCRIPT.TYPE], '') != '' 
	 AND   COALESCE([INSTA.TRANSCRIPT.DATE], '') != ''
	 AND   COALESCE([INSTA.TRANSCRIPT.STATUS], '') != ''

), insta AS (
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
		  --,.insta.[INSTA.PE]
		  ,insta.[EffectiveDatetime]
		  ,[ExpirationDateTime]
	FROM [history].[INSTITUTIONS_ATTEND] insta
		LEFT JOIN adate
			ON (adate.[INSTA.PERSON.ID] = insta.[INSTA.PERSON.ID]
				AND adate.[EffectiveDatetime] = insta.[EffectiveDatetime])
		LEFT JOIN tdate
			ON (tdate.[INSTA.PERSON.ID] = insta.[INSTA.PERSON.ID]
				AND adate.[EffectiveDatetime] = insta.[EffectiveDatetime])
	WHERE  insta.[EffectiveDatetime] <= @report_date
	AND   (insta.[ExpirationDatetime] is null
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
		INNER JOIN trm ON (trm.[STTR.STUDENT] = insta.[INSTA.PERSON.ID]);

/*
EXEC datamart.getSTUDENT_07 '2018', '01', '02/23/2018'

--, '2018SP'
*/