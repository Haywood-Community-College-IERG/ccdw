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

WITH xnc_hs AS (
    SELECT [XNC.PERSON.ID]
         , CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(12)) AS [XNC.HIGH.SCHOOL.TRACK]
         , CA1.ItemNumber AS ItemNumber
         , EffectiveDatetime
      FROM [history].[XNC_PERSON]
     CROSS APPLY dbo.DelimitedSplit8K([XNC.HIGH.SCHOOL.TRACK], ', ') CA1 
     WHERE COALESCE([XNC.HIGH.SCHOOL.TRACK], '') != '' 
), xnc AS (
	SELECT xnc.[XNC.PERSON.ID]
		  ,xnc.[XNC.INMATE.FLAG]
		  ,xnc.[XNC.ECON.DISADVANTAGED.FLAG]
	      ,xnc.[XNC.SINGLE.PARENT.FLAG]
	      ,xnc.[XNC.HEAD.HOUSEHOLD.FLAG]
	      ,xnc.[XNC.LIMITED.ENGLISH.FLAG]
	      ,xnc_hs.[XNC.HIGH.SCHOOL.TRACK]
	      ,xnc.[XNC.EDU.ENTRY.LEVEL]
	      ,xnc.[XNC.FATHER.DEGREE.FLAG]
	      ,xnc.[XNC.MOTHER.DEGREE.FLAG]
	      ,xnc.[EffectiveDatetime]
	      ,xnc.[ExpirationDatetime]
	FROM   [history].[XNC_PERSON] xnc
    LEFT JOIN xnc_hs 
         ON (xnc_hs.[XNC.PERSON.ID] = xnc.[XNC.PERSON.ID]
             AND xnc_hs.EffectiveDatetime = xnc.EffectiveDatetime)
	WHERE  xnc.[EffectiveDatetime] <= @report_date
	AND   (xnc.[ExpirationDatetime] is null
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
SELECT	xnc.[XNC.PERSON.ID]
		,xnc.[XNC.INMATE.FLAG]
		,xnc.[XNC.ECON.DISADVANTAGED.FLAG]
	    ,xnc.[XNC.SINGLE.PARENT.FLAG]
	    ,xnc.[XNC.HEAD.HOUSEHOLD.FLAG]
	    ,xnc.[XNC.LIMITED.ENGLISH.FLAG]
	    ,xnc.[XNC.HIGH.SCHOOL.TRACK]
	    ,xnc.[XNC.EDU.ENTRY.LEVEL]
        --,xnc.[XNC.EDUCATIONAL.LEVEL]
	    ,xnc.[XNC.FATHER.DEGREE.FLAG]
	    ,xnc.[XNC.MOTHER.DEGREE.FLAG]
FROM xnc 
	INNER JOIN trm ON (trm.[STTR.STUDENT] = xnc.[XNC.PERSON.ID])
;
/*
EXEC datamart.getSTUDENT_03 '2018', '01', '02/23/2018'

--, '2018SP'
*/