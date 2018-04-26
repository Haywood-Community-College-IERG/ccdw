WITH per_addr AS (
    SELECT [ID]
         , CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(12)) AS [ADDR.TYPE]
         , CA1.ItemNumber AS ItemNumber
         , EffectiveDatetime
      FROM [history].[PERSON]
     CROSS APPLY dbo.DelimitedSplit8K([ADDR.TYPE], ', ') CA1 
     WHERE COALESCE([ADDR.TYPE], '') != '' 
), per AS (
	SELECT per.[ID]
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
      ,[EMER.CONTACT.PHONE]
      ,[PERSON.OVRL.EMP.STAT]
      ,[VETERAN.TYPE]
      ,[VETERAN.TYPE2.DESCRIPTION]
      ,[VISA.TYPE]
      ,[PRIVACY.FLAG]
      ,[DIRECTORY.FLAG]
      ,per_email.[PERSON.EMAIL.ADDRESSES]
      ,per_email.[PERSON.EMAIL.TYPES]
      ,per_phone.[PERSONAL.PHONE.NUMBER]
      ,per_phone.[PERSONAL.PHONE.TYPE]
      ,[PERSON.ADD.DATE]
      ,[PERSON.ADD.OPERATOR]
      ,[PERSON.CHANGE.DATE]
      ,[PERSON.CHANGE.OPERATOR]
	  --,[PER.PRI.ETHNIC]
	  --,[PER.PRI.RACE]
      ,per.[EffectiveDatetime]
      ,[ExpirationDatetime]
      ,[CurrentFlag]
	FROM   [history].[PERSON] per
	LEFT JOIN history.PERSON__NAMEHIST per_name
		 ON (per_name.[ID] = per.[ID]
			 and per_name.EffectiveDatetime = per.EffectiveDatetime)
    LEFT JOIN per_addr 
         ON (per_addr.[ID] = per.[ID]
             AND per_addr.EffectiveDatetime = per.EffectiveDatetime)
	LEFT JOIN history.PERSON__PEOPLE_EMAIL per_email
         ON (per_email.[ID] = per.[ID]
             AND per_email.EffectiveDatetime = per.EffectiveDatetime)
	LEFT JOIN history.PERSON__PERPHONE per_phone
         ON (per_phone.[ID] = per.[ID]
             AND per_phone.EffectiveDatetime = per.EffectiveDatetime)
	WHERE  per.[EffectiveDatetime] <= '02/23/2018'
	AND   (per.[ExpirationDatetime] is null
	OR	   [ExpirationDatetime] > '02/23/2018')

) UPDATE per SET
	   per.[ID] = ''
	  ,per.[CITIZENSHIP] = ''
	  ,per.[PERSON.ALT.IDS] = ''
      ,per.[FIRST.NAME]= ''
      ,per.[MIDDLE.NAME] = ''
      ,per.[LAST.NAME] = ''
      ,per.[SUFFIX] = ''
      ,per.[ADDRESS.LINES] = ''
      ,per.[CITY] = ''
      ,per.[STATE] = ''
      ,per.[ZIP] = ''
      ,per.[GENDER] = ''
      ,per.[BIRTH.DATE] = ''
      ,per.[DECEASED.DATE] = ''
      ,per.[MARITAL.STATUS] = ''
      ,per.[ETHNIC] = ''
      ,per.[PER.ETHNICS] = ''
      ,per.[PER.RACES] = ''
	  --,per.[COUNTRY]
      ,per.[RESIDENCE.COUNTY] = ''
      ,per.[RESIDENCE.STATE] = ''
      ,per.[RESIDENCE.COUNTRY] = ''
	  --,per.[DRIVER.LICENSE.STATE]
	  --,per.[DRIVER.LICENSE.NO]
      ,per.[EMER.CONTACT.PHONE] = ''
      ,per.[PERSON.OVRL.EMP.STAT] = ''
      ,per.[VETERAN.TYPE] = ''
      ,per.[VETERAN.TYPE2.DESCRIPTION] = ''
      ,per.[VISA.TYPE] = ''
      ,per.[PRIVACY.FLAG] = ''
      ,per.[DIRECTORY.FLAG] = ''
      ,per.[PERSON.ADD.DATE] = ''
      ,per.[PERSON.ADD.OPERATOR] = ''
      ,per.[PERSON.CHANGE.DATE] = ''
      ,per.[PERSON.CHANGE.OPERATOR] = ''
	  --,per.[PER.PRI.ETHNIC]
	  --,per.[PER.PRI.RACE]
	  FROM per
	  WHERE LAG (PER.[ID],1) = (per.[ID])
;
/*
EXEC datamart.getSTUDENT_02 '2018', '01', '02/23/2018'

--, '2018SP'
*/