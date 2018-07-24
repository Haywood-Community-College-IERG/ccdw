WITH cs AS (
		SELECT [COURSE.SECTIONS.ID]
		     , [SEC.MEETING]
			 , [SEC.COURSE]
			 , [SEC.TERM]
			 , [SEC.NO]
			 , [SEC.LOCATION]
		  FROM [IERG].[history].[COURSE_SECTIONS]
		 WHERE [EffectiveDatetime] <= '02/23/2018'
	      AND ([ExpirationDatetime] is null
	           OR [ExpirationDatetime] > '02/23/2018')
	), csm AS (
		SELECT csm.[COURSE.SEC.MEETING.ID]
		      ,csm.[CSM.COURSE.SECTION]
			  ,csm.[COURSE.SEC.MEETING.ADDDATE]
			  ,csm.[COURSE.SEC.MEETING.ADDOPR]
			  ,csm.[COURSE.SEC.MEETING.CHGDATE]
			  ,csm.[COURSE.SEC.MEETING.CHGOPR]
			  ,csm.[CSM.START.DATE]
			  ,csm.[CSM.START.TIME]
			  ,csm.[CSM.END.DATE]
			  ,csm.[CSM.END.TIME]
			  ,cday.[CSM.DAYS]
			  ,csm.[CSM.BLDG]
			  ,csm.[CSM.ROOM]
			  ,csm.[CSM.INSTR.METHOD]
		  FROM [IERG].[history].[COURSE_SEC_MEETING] csm
		  LEFT JOIN [IERG].[history].[COURSE_SEC_MEETING__CSM_DAYS_ASSOC] cday
		  	   ON (cday.[COURSE.SEC.MEETING.ID] = csm.[COURSE.SEC.MEETING.ID]
					 AND cday.[EffectiveDatetime] = csm.[EffectiveDatetime])
		 WHERE csm.[EffectiveDatetime] <= '02/23/2018'
	      AND (csm.[ExpirationDatetime] is null
	           OR csm.[ExpirationDatetime] > '02/23/2018')
	), c AS (
		SELECT [COURSES.ID]
			 , [CRS.SUBJECT]
			 , [CRS.NO]
		  FROM [IERG].[history].[COURSES]
		 WHERE [EffectiveDatetime] <= '02/23/2018'
	      AND ([ExpirationDatetime] is null
	           OR [ExpirationDatetime] > '02/23/2018')
	), lag AS (
		SELECT cs.*, c.*, csm.*,
			LAG(c.[CRS.NO]) OVER (ORDER BY c.[CRS.NO]) CRS_LAG
		FROM cs, c, csm
	)
	SELECT LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN lag.[CRS.NO] ELSE '' END + REPLICATE(' ', 6), 6)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN lag.[SEC.TERM] ELSE '' END + REPLICATE(' ', 7), 7)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN lag.[CRS.SUBJECT] ELSE '' END + REPLICATE(' ', 4), 4)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN lag.[SEC.NO] ELSE '' END + REPLICATE(' ', 6), 6)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN CAST(lag.[COURSE.SEC.MEETING.ADDDATE] as varchar) ELSE '' END + REPLICATE(' ', 8), 8)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN CAST(lag.[COURSE.SEC.MEETING.ADDOPR] as varchar) ELSE '' END + REPLICATE(' ', 8), 8)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN CAST(lag.[COURSE.SEC.MEETING.CHGDATE] as varchar) ELSE '' END + REPLICATE(' ', 8), 8)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN lag.[COURSE.SEC.MEETING.CHGOPR] ELSE '' END + REPLICATE(' ', 8), 8)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN CAST(lag.[CSM.START.DATE] as varchar) ELSE '' END + REPLICATE(' ', 8), 8)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN CAST(lag.[CSM.START.TIME] as varchar) ELSE '' END + REPLICATE(' ', 8), 8)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN CAST(lag.[CSM.END.DATE] as varchar) ELSE '' END + REPLICATE(' ', 8), 8)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN CAST(lag.[CSM.END.TIME] as varchar) ELSE '' END + REPLICATE(' ', 8), 8)
		 , LEFT(COALESCE(lag.[CSM.DAYS],'') + REPLICATE(' ', 8), 8)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN lag.[SEC.LOCATION] ELSE '' END + REPLICATE(' ', 8), 8)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN lag.[CSM.BLDG] ELSE '' END + REPLICATE(' ', 8), 8)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN lag.[CSM.ROOM] ELSE '' END + REPLICATE(' ', 8), 8)
		 , LEFT(CASE WHEN lag.[CRS.NO] <> lag.CRS_LAG THEN lag.[CSM.INSTR.METHOD] ELSE '' END + REPLICATE(' ', 8), 8)
	  FROM lag
	  LEFT JOIN csm ON (lag.[COURSE.SEC.MEETING.ID] = lag.[SEC.MEETING])
	  LEFT JOIN c   ON (lag.[COURSES.ID] = lag.[SEC.COURSE])
	 WHERE lag.[SEC.TERM] IN ('2018', '01') /*'2018SP'*/
;
/*
EXEC datamart.getCLASS_01 '2018', '01', '02/23/2018'

--, '2018SP'
*/