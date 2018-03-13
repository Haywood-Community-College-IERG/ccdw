IF OBJECT_ID('datamart.getSTUDENT_02', 'P') IS NOT NULL
	DROP PROCEDURE datamart.getSTUDENT_02
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

WITH per_addr AS (
    SELECT [ID]
         , CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(12)) AS [ADDR.TYPE]
         , CA1.ItemNumber AS ItemNumber
         , EffectiveDatetime
      FROM [history].[PERSON]
     CROSS APPLY dbo.DelimitedSplit8K([ADDR.TYPE], ', ') CA1 
     WHERE COALESCE([ADDR.TYPE], '') != '' 
), per_name AS (
	    SELECT [ID]
         , CAST(LTRIM(RTRIM(CA2.Item)) AS VARCHAR(12)) AS [NAME.HISTORY.LAST.NAME]
         , CA2.ItemNumber AS ItemNumber
         , EffectiveDatetime
      FROM [history].[PERSON]
     CROSS APPLY dbo.DelimitedSplit8K([NAME.HISTORY.LAST.NAME], ', ') CA2 
     WHERE COALESCE([NAME.HISTORY.LAST.NAME], '') != '' 
), per_email AS (
	    SELECT [ID]
         , CAST(LTRIM(RTRIM(CA3.Item)) AS VARCHAR(12)) AS [PERSON.EMAIL.ADDRESSES]
         , CA3.ItemNumber AS ItemNumber
         , EffectiveDatetime
      FROM [history].[PERSON]
     CROSS APPLY dbo.DelimitedSplit8K([PERSON.EMAIL.ADDRESSES], ', ') CA3 
     WHERE COALESCE([PERSON.EMAIL.ADDRESSES], '') != '' 
), per_ematye AS (
	    SELECT [PERSON.EMAIL.ADDRESSES]
         , CAST(LTRIM(RTRIM(CA4.Item)) AS VARCHAR(12)) AS [PERSON.EMAIL.TYPES]
         , CA4.ItemNumber AS ItemNumber
         , EffectiveDatetime
      FROM [history].[PERSON]
     CROSS APPLY dbo.DelimitedSplit8K([PERSON.EMAIL.TYPES], ', ') CA4 
     WHERE COALESCE([PERSON.EMAIL.TYPES], '') != '' 
), per_phone AS (
	    SELECT [ID]
         , CAST(LTRIM(RTRIM(CA5.Item)) AS VARCHAR(12)) AS [PERSONAL.PHONE.NUMBER]
         , CA5.ItemNumber AS ItemNumber
         , EffectiveDatetime
      FROM [history].[PERSON]
     CROSS APPLY dbo.DelimitedSplit8K([PERSONAL.PHONE.NUMBER], ', ') CA5 
     WHERE COALESCE([PERSONAL.PHONE.NUMBER], '') != '' 
), per_photye AS (
	    SELECT [PERSONAL.PHONE.NUMBER]
         , CAST(LTRIM(RTRIM(CA6.Item)) AS VARCHAR(12)) AS [PERSONAL.PHONE.TYPE]
         , CA6.ItemNumber AS ItemNumber
         , EffectiveDatetime
      FROM [history].[PERSON]
     CROSS APPLY dbo.DelimitedSplit8K([PERSONAL.PHONE.TYPE], ', ') CA6 
     WHERE COALESCE([PERSONAL.PHONE.TYPE], '') != '' 
), per AS (
	SELECT [ID]
	  ,[CITIZENSHIP]
	  ,[PERSON.ALT.IDS]
      ,[FIRST.NAME]
      ,[MIDDLE.NAME]
      ,[LAST.NAME]
      ,[SUFFIX]
      ,per_name.[NAME.HISTORY.LAST.NAME]
      ,[ADDRESS.LINES]
      ,[CITY]
      ,[STATE]
      ,[ZIP]
      ,per_addr.[ADDR.TYPE]
      ,[GENDER]
      ,[BIRTH.DATE]
      ,[DECEASED.DATE]
      ,[MARITAL.STATUS]
      ,[ETHNIC]
      ,[PER.ETHNICS]
      ,[PER.RACES]
	  --,[COUNTRY]
      ,[RESIDENCE.COUNTY]
      ,[RESIDENCE.STATE]
      ,[RESIDENCE.COUNTRY]
	  --,[DRIVER.LICENSE.STATE]
	  --,[DRIVER.LICENSE.NO]
	  ,[MARITAL.STATUS]
      ,[EMER.CONTACT.PHONE]
      ,[PERSON.OVRL.EMP.STAT]
      ,[VETERAN.TYPE]
      ,[VETERAN.TYPE2.DESCRIPTION]
      ,[VISA.TYPE]
      ,[PRIVACY.FLAG]
      ,[DIRECTORY.FLAG]
      ,per_email.[PERSON.EMAIL.ADDRESSES]
      ,per_ematye.[PERSON.EMAIL.TYPES]
      ,per_phone.[PERSONAL.PHONE.NUMBER]
      ,per_photye.[PERSONAL.PHONE.TYPE]
      ,[PERSON.ADD.DATE]
      ,[PERSON.ADD.OPERATOR]
      ,[PERSON.CHANGE.DATE]
      ,[PERSON.CHANGE.OPERATOR]
	  --,[PER.PRI.ETHNIC]
	  --,[PER.PRI.RACE]
      ,[EffectiveDatetime]
      ,[ExpirationDatetime]
      ,[CurrentFlag]
	FROM   [history].[PERSON] per
    LEFT JOIN per_addr 
         ON (per_addr.[ID] = per.[ID]
             AND per_addr.EffectiveDatetime = per.EffectiveDatetime)
	WHERE  per.[EffectiveDatetime] <= @report_date
	AND   (per.[ExpirationDatetime] is null
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
SELECT	per.[ID]
	  ,per.[CITIZENSHIP]
	  ,per.[PERSON.ALT.IDS]
      ,per.[FIRST.NAME]
      ,per.[MIDDLE.NAME]
      ,per.[LAST.NAME]
      ,per.[SUFFIX]
      ,per.[NAME.HISTORY.LAST.NAME]
      ,per.[ADDRESS.LINES]
      ,per.[CITY]
      ,per.[STATE]
      ,per.[ZIP]
      ,per.[ADDR.TYPE]
      ,per.[GENDER]
      ,per.[BIRTH.DATE]
      ,per.[DECEASED.DATE]
      ,per.[MARITAL.STATUS]
      ,per.[ETHNIC]
      ,per.[PER.ETHNICS]
      ,per.[PER.RACES]
	  --,per.[COUNTRY]
      ,per.[RESIDENCE.COUNTY]
      ,per.[RESIDENCE.STATE]
      ,per.[RESIDENCE.COUNTRY]
	  --,per.[DRIVER.LICENSE.STATE]
	  --,per.[DRIVER.LICENSE.NO]
	  ,per.[MARITAL.STATUS]
      ,per.[EMER.CONTACT.PHONE]
      ,per.[PERSON.OVRL.EMP.STAT]
      ,per.[VETERAN.TYPE]
      ,per.[VETERAN.TYPE2.DESCRIPTION]
      ,per.[VISA.TYPE]
      ,per.[PRIVACY.FLAG]
      ,per.[DIRECTORY.FLAG]
      ,per.[PERSON.EMAIL.ADDRESSES]
      ,per.[PERSON.EMAIL.TYPES]
      ,per.[PERSONAL.PHONE.NUMBER]
      ,per.[PERSONAL.PHONE.TYPE]
      ,per.[PERSON.ADD.DATE]
      ,per.[PERSON.ADD.OPERATOR]
      ,per.[PERSON.CHANGE.DATE]
      ,per.[PERSON.CHANGE.OPERATOR]
	  --,per.[PER.PRI.ETHNIC]
	  --,per.[PER.PRI.RACE]
FROM per 
	INNER JOIN trm ON (trm.[STTR.STUDENT] = per.[ID])
;
/*
EXEC datamart.getSTUDENT_03 '2018', '01', '02/23/2018'

--, '2018SP'
*/