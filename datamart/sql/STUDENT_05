SELECT [STNC.PERSON.ID]
	  ,[STNC.SOURCE]
	  ,[NCRS.TYPE]
	  ,[STNC.CATEGORY]
	  --,[STNC.CATEGORY.TRANSLATION]
	  ,[STNC.START.DATE]
	  ,[STNC.END.DATE]
	  ,[STNC.STATUS]
	  --,[STNC.STATUS.DATE]
	  ,[STNC.NON.COURSE]
	  ,[STNC.TITLE]
	  ,[STNC.SCORE]
FROM [IERG].[history].[STUDENT_NON_COURSES]
    ,[IERG].[history].[NON_COURSES]
WHERE [STNC.NON.COURSE] = [NON.COURSES.ID]
and [STUDENT_NON_COURSES].[EffectiveDatetime] <= '01/31/2018'
and ([STUDENT_NON_COURSES].[ExpirationDatetime] is null
or [STUDENT_NON_COURSES].[ExpirationDatetime] > '01/31/2018')
and [NON_COURSES].[EffectiveDatetime] <= '01/31/2018'
and ([NON_COURSES].[ExpirationDatetime] is null
or [NON_COURSES].[ExpirationDatetime] > '01/31/2018')