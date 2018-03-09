SELECT [SEC.TERM]
	  ,[CRS.SUBJECT]
	  ,[SEC.COURSE]
	  ,[SEC.NO]
	  ,[COURSE.SEC.MEETING.ADDDATE]
	  ,[COURSE.SEC.MEETING.ADDOPR]
	  ,[COURSE.SEC.MEETING.CHGDATE]
	  ,[COURSE.SEC.MEETING.CHGOPR]
	  ,[CSM.START.DATE]
	  ,[CSM.START.TIME]
	  ,[CSM.END.DATE]
	  ,[CSM.END.TIME]
	  ,[CSM.DAYS]
	  ,[SEC.LOCATION]
	  ,[CSM.BLDG]
	  ,[CSM.ROOM]
	  ,[CSM.INSTR.METHOD]
FROM [IERG].[history].[COURSE_SECTIONS]
	,[IERG].[history].[COURSE_SEC_MEETING]
	,[IERG].[history].[COURSES]
WHERE [COURSE.SECTIONS.ID] = [COURSE.SEC.MEETING.ID]
and [COURSES.ID] = [SEC.COURSE]
and [COURSE_SECTIONS].[EffectiveDatetime] <= '01/31/2018'
and ([COURSE_SECTIONS].[ExpirationDatetime] is null
or [COURSE_SECTIONS].[ExpirationDatetime] > '01/31/2018')
and [COURSE_SEC_MEETING].[EffectiveDatetime] <= '01/31/2018'
and ([COURSE_SEC_MEETING].[ExpirationDatetime] is null
or [COURSE_SEC_MEETING].[ExpirationDatetime] > '01/31/2018')
and [COURSES].[EffectiveDatetime] <= '01/31/2018'
and ([COURSES].[ExpirationDatetime] is null
or [COURSES].[ExpirationDatetime] > '01/31/2018')
And [SEC.TERM] = '2017FA'