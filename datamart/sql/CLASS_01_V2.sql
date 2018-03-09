IF OBJECT_ID('datamart.getCLASS_01', 'P') IS NOT NULL
    DROP PROCEDURE datamart.getCLASS_01
GO

CREATE PROCEDURE datamart.getCLASS_01
	@data_year varchar(4),
	@data_term varchar(2),
	@report_date date /*= GETDATE*/
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

	WITH cs AS (
		SELECT [COURSE.SECTIONS.ID]
		     , [SEC.MEETING]
			 , [SEC.COURSE]
			 , [SEC.TERM]
			 , [SEC.NO]
			 , [SEC.LOCATION]
		  FROM [IERG].[history].[COURSE_SECTIONS]
		 WHERE [EffectiveDatetime] <= @report_date /* '02/23/2018' */
	      AND ([ExpirationDatetime] is null
	           OR [ExpirationDatetime] > @report_date /* '02/23/2018' */)
	), csm AS (
		SELECT [COURSE_SEC_MEETING].[COURSE.SEC.MEETING.ID]
		      ,[COURSE_SEC_MEETING].[CSM.COURSE.SECTION]
			  ,[COURSE_SEC_MEETING].[COURSE.SEC.MEETING.ADDDATE]
			  ,[COURSE_SEC_MEETING].[COURSE.SEC.MEETING.ADDOPR]
			  ,[COURSE_SEC_MEETING].[COURSE.SEC.MEETING.CHGDATE]
			  ,[COURSE_SEC_MEETING].[COURSE.SEC.MEETING.CHGOPR]
			  ,[COURSE_SEC_MEETING].[CSM.START.DATE]
			  ,[COURSE_SEC_MEETING].[CSM.START.TIME]
			  ,[COURSE_SEC_MEETING].[CSM.END.DATE]
			  ,[COURSE_SEC_MEETING].[CSM.END.TIME]
			  ,[COURSE_SEC_MEETING__CSM_DAYS_ASSOC].[CSM.DAYS]
			  ,[COURSE_SEC_MEETING].[CSM.BLDG]
			  ,[COURSE_SEC_MEETING].[CSM.ROOM]
			  ,[COURSE_SEC_MEETING].[CSM.INSTR.METHOD]
		  FROM [IERG].[history].[COURSE_SEC_MEETING]
		  LEFT JOIN [IERG].[history].[COURSE_SEC_MEETING__CSM_DAYS_ASSOC]
		  	   ON ([COURSE_SEC_MEETING__CSM_DAYS_ASSOC].[COURSE.SEC.MEETING.ID] = [COURSE_SEC_MEETING].[COURSE.SEC.MEETING.ID]
					 AND [COURSE_SEC_MEETING__CSM_DAYS_ASSOC].[EffectiveDatetime] = [COURSE_SEC_MEETING].[EffectiveDatetime])
		 WHERE [COURSE_SEC_MEETING].[EffectiveDatetime] <= @report_date /* '02/23/2018' */
	      AND ([COURSE_SEC_MEETING].[ExpirationDatetime] is null
	           OR [COURSE_SEC_MEETING].[ExpirationDatetime] > @report_date /* '02/23/2018' */)
	), c AS (
		SELECT [COURSES.ID]
			 , [CRS.SUBJECT]
			 , [CRS.NO]
		  FROM [IERG].[history].[COURSES]
		 WHERE [EffectiveDatetime] <= @report_date /* '02/23/2018' */
	      AND ([ExpirationDatetime] is null
	           OR [ExpirationDatetime] > @report_date /* '02/23/2018' */)
	)
	SELECT cs.[SEC.TERM]
		 , c.[CRS.SUBJECT]
		 , c.[CRS.NO]
		 , cs.[SEC.NO]
		 , csm.[COURSE.SEC.MEETING.ADDDATE]
		 , csm.[COURSE.SEC.MEETING.ADDOPR]
		 , csm.[COURSE.SEC.MEETING.CHGDATE]
		 , csm.[COURSE.SEC.MEETING.CHGOPR]
		 , csm.[CSM.START.DATE]
		 , csm.[CSM.START.TIME]
		 , csm.[CSM.END.DATE]
		 , csm.[CSM.END.TIME]
		 , csm.[CSM.DAYS]
		 , cs.[SEC.LOCATION]
		 , csm.[CSM.BLDG]
		 , csm.[CSM.ROOM]
		 , csm.[CSM.INSTR.METHOD]
	  FROM cs
	  LEFT JOIN csm ON (csm.[COURSE.SEC.MEETING.ID] = cs.[SEC.MEETING])
	  LEFT JOIN c   ON (c.[COURSES.ID] = cs.[SEC.COURSE])
	 WHERE cs.[SEC.TERM] IN (@term_id_ce, @term_id_cu) /*'2018SP'*/
;
/*
EXEC datamart.getCLASS_01 '2018', '01', '02/23/2018'

--, '2018SP'
*/