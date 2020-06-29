DROP VIEW [history].[ACAD_CREDENTIALS_Current]
GO
CREATE VIEW [history].[ACAD_CREDENTIALS_Current] AS
    SELECT 
           [ACAD.CREDENTIALS.ID],	
           [ACAD.PERSON.ID],	
           [ACAD.ACAD.PROGRAM],	
           [ACAD.MAJORS],	
           [ACAD.TERM],	
           [ACAD.TRANSCRIPT.ADDRESS],	
           [ACAD.TRANSCRIPT.CITY],	
           [ACAD.TRANSCRIPT.STATE],	
           [ACAD.TRANSCRIPT.ZIP],	
           [ACAD.TRANSCRIPT.COUNTRY],	
           [ACAD.INSTITUTIONS.ID],	
           [ACAD.GPA],	
           [ACAD.START.DATE],	
           [ACAD.END.DATE],	
           [ACAD.CAST.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [ACAD.DEGREE],	
           [ACAD.CCD],	
           [ACAD.DEGREE.DATE],	
           [ACAD.COMMENCEMENT.DATE],	
           [ACAD.CCD.DATE]
      FROM [history].[ACAD_CREDENTIALS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[ACAD_PROGRAM_REQMTS_Current]
GO
CREATE VIEW [history].[ACAD_PROGRAM_REQMTS_Current] AS
    SELECT 
           [ACAD.PROGRAM.REQMTS.ID],	
           [ACPR.ACAD.REQMTS],	
           [ACPR.ACAD.CRED.RULES],	
           [ACPR.ACAD.PROGRAM],	
           [ACPR.CATALOG],	
           [ACPR.CRED],	
           [ACPR.MIN.GPA],	
           [ACPR.MIN.GRADE],	
           [ACPR.ADDNL.CCD.PL],	
           [ACPR.ADDNL.MAJOR.PL],	
           [ACPR.ADDNL.MINOR.PL],	
           [ACPR.ADDNL.SPECIALIZATION.PL],	
           [ACPR.CURRICULUM.TRACK],	
           [ACPR.DURATION.HOURS],	
           [ACPR.INSTITUTION.GPA],	
           [ACPR.INSTITUTION.CRED],	
           [ACPR.MAX.CRED],	
           [ACPR.OTHER.GRADES],	
           [ACPR.PROGRAM.REVIEW],	
           [ACAD.PROGRAM.REQMTS.ADDOPR],	
           [ACAD.PROGRAM.REQMTS.ADDDATE],	
           [ACAD.PROGRAM.REQMTS.CHGOPR],	
           [ACAD.PROGRAM.REQMTS.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[ACAD_PROGRAM_REQMTS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[ACAD_PROGRAMS_Current]
GO
CREATE VIEW [history].[ACAD_PROGRAMS_Current] AS
    SELECT 
           [ACAD.PROGRAMS.ID],	
           [ACPG.TITLE],	
           [ACPG.DEGREE],	
           [ACPG.ACAD.LEVEL],	
           [ACPG.TYPES],	
           [ACPG.MAJORS],	
           [ACPG.MINORS],	
           [ACPG.CIP],	
           [ACPG.CMPL.MONTHS],	
           [ACPG.TERM.LENGTH],	
           [ACPG.ACCRED.EXPIRE.DATE],	
           [ACPG.ACAD.STANDINGS],	
           [ACPG.ADDNL.CCDS],	
           [ACPG.ADDNL.MAJORS],	
           [ACPG.ADMIT.CAPACITY],	
           [ACPG.ADMIT.RULES],	
           [ACPG.APPLICATION.STATUS],	
           [ACPG.ALLOW.GRADUATION.FLAG],	
           [ACPG.GRADE.SCHEME],	
           [ACPG.STUDENT.SELECT.FLAG],	
           [ACPG.TRANSCRIPT.GROUPING],	
           [ACPG.LOCATIONS],	
           [ACPG.SCHOOLS],	
           [ACPG.DIVISIONS],	
           [DIV.DESC],	
           [ACPG.DEPTS],	
           [DEPTS.DESC],	
           [ACPG.START.DATE],	
           [ACPG.END.DATE],	
           [ACPG.CATALOGS],	
           [ACPG.APPROVAL.IDS],	
           [ACPG.APPROVAL.AGENCY.IDS],	
           [ACPG.APPROVAL.DATES],	
           [ACPG.STATUS],	
           [ACPG.STATUS.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [ACPG.DESC]
      FROM [history].[ACAD_PROGRAMS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[ACAD_PROGRAMS__USER_Current]
GO
CREATE VIEW [history].[ACAD_PROGRAMS__USER_Current] AS
    SELECT 
           [USER.ACPG.PROGRAMS.ID],	
           [USER.ACPG.DEPARTMENT_CODE],	
           [USER.ACPG.DEPARTMENT_DESC],	
           [USER.ACPG.PROGRAM_AREA_CODE],	
           [USER.ACPG.PROGRAM_AREA_DESC],	
           [USER.ACPG.ALTERNATE_GROUP_CODE],	
           [USER.ACPG.ALTERNATE_GROUP_DESC],	
           [USER.ACPG.PERFORMANCE_INDICATOR_PROGRAM_AREA_CODE],	
           [USER.ACPG.PERFORMANCE_INDICATOR_PROGRAM_AREA_DESC],	
           [USER.ACPG.HIGH_SCHOOL],	
           [USER.ACPG.DISCONTINUED],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [USER.ACPG.MAJOR.HOURS.MAX],	
           [USER.ACPG.MAJOR.HOURS],	
           [USER.ACPG.MAJOR_CODE_DESC],	
           [USER.ACPG.CAREER_CLUSTER],	
           [USER.ACPG.MAJOR_AREA]
      FROM [history].[ACAD_PROGRAMS__USER]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[ACAD_REQMT_BLOCKS_Current]
GO
CREATE VIEW [history].[ACAD_REQMT_BLOCKS_Current] AS
    SELECT 
           [ACAD.REQMT.BLOCKS.ID],	
           [ACRB.ACAD.CRED.RULES],	
           [ACRB.ACAD.REQMT],	
           [ACRB.ALLOWED.GRADES],	
           [ACRB.BUT.NOT.COURSES],	
           [ACRB.BUT.NOT.CRS.LEVELS],	
           [ACRB.BUT.NOT.DEPTS],	
           [ACRB.BUT.NOT.SUBJECTS],	
           [ACRB.COURSE.REUSE.FLAG],	
           [ACRB.COURSES],	
           [ACRB.FROM.COURSES],	
           [ACRB.FROM.CRS.LEVELS],	
           [ACRB.FROM.DEPTS],	
           [ACRB.FROM.SUBJECTS],	
           [ACRB.LABEL],	
           [ACRB.MAX.COURSES.PER.DEPT],	
           [ACRB.MAX.COURSES.PER.RULE],	
           [ACRB.MAX.COURSES.PER.SUBJECT],	
           [ACRB.MAX.COURSES.RULES],	
           [ACRB.MAX.CRED],	
           [ACRB.MAX.CRED.PER.COURSE],	
           [ACRB.MAX.CRED.PER.DEPT],	
           [ACRB.MAX.CRED.PER.RULE],	
           [ACRB.MAX.CRED.PER.SUBJECT],	
           [ACRB.MAX.CRED.RULES],	
           [ACRB.MAX.NO.COURSES],	
           [ACRB.MAX.NO.DEPTS],	
           [ACRB.MAX.NO.SUBJECTS],	
           [ACRB.MIN.COURSES.PER.DEPT],	
           [ACRB.MIN.COURSES.PER.SUBJECT],	
           [ACRB.MIN.CRED],	
           [ACRB.MIN.CRED.PER.COURSE],	
           [ACRB.MIN.CRED.PER.DEPT],	
           [ACRB.MIN.CRED.PER.SUBJECT],	
           [ACRB.MIN.GRADE],	
           [ACRB.MIN.NO.COURSES],	
           [ACRB.MIN.NO.DEPTS],	
           [ACRB.MIN.NO.SUBBLOCKS],	
           [ACRB.MIN.NO.SUBJECTS],	
           [ACRB.NO.LEVEL.COURSES.LEVELS],	
           [ACRB.NO.LEVEL.CRED],	
           [ACRB.NO.LEVEL.CRED.LEVELS],	
           [ACRB.NO.LEVEL.NO.COURSES],	
           [ACRB.PARENT.BLOCK],	
           [ACRB.PRINTED.SPEC],	
           [ACRB.SUBBLOCKS],	
           [ACRB.SUBROUTINE],	
           [ACRB.TYPE],	
           [ACRB.EXCL.FIRST.ONLY.FLAGS],	
           [ACRB.EXCL.REQMT.TYPES],	
           [ACRB.EXTRA.CODE],	
           [ACRB.INCLUDE.FAILURES],	
           [ACRB.IN.LIST.ORDER],	
           [ACRB.INSTITUTION.CRED],	
           [ACRB.MERGE.METHOD],	
           [ACRB.MIN.GPA],	
           [ACRB.SORT.METHOD],	
           [ACRB.STUDENT.DA.EXCPTS],	
           [ACAD.REQMT.BLOCKS.ADDOPR],	
           [ACAD.REQMT.BLOCKS.ADDDATE],	
           [ACAD.REQMT.BLOCKS.CHGOPR],	
           [ACAD.REQMT.BLOCKS.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[ACAD_REQMT_BLOCKS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[ACAD_REQMTS_Current]
GO
CREATE VIEW [history].[ACAD_REQMTS_Current] AS
    SELECT 
           [ACAD.REQMTS.ID],	
           [ACR.ACAD.PROGRAM.REQMTS],	
           [ACR.ACAD.LEVEL],	
           [ACR.CUSTOM.REQMT.FLAG],	
           [ACR.CUSTOM.USE.FLAG],	
           [ACR.PRINTED.SPEC],	
           [ACR.REQS.COURSE],	
           [ACR.REQS.ENFORCEMENT],	
           [ACR.REQS.PROTECT.FLAG],	
           [ACR.REQS.SECTION],	
           [ACR.REQS.TIMING],	
           [ACR.TOP.REQMT.BLOCK],	
           [ACR.CATALOGS],	
           [ACR.CCDS],	
           [ACR.COMMENTS],	
           [ACR.DEPTS],	
           [REQMT.DESCRIPTION],	
           [ACR.DESC],	
           [ACR.GRADE.SCHEME],	
           [ACR.MAJORS],	
           [ACR.MINORS],	
           [ACR.PREREQ.COURSE],	
           [ACR.SPECIALIZATIONS],	
           [ACR.STUDENT.PROGRAMS],	
           [ACR.TYPE],	
           [ACAD.REQMTS.ADDOPR],	
           [ACAD.REQMTS.ADDDATE],	
           [ACAD.REQMTS.CHGOPR],	
           [ACAD.REQMTS.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[ACAD_REQMTS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[ADDRESS_Current]
GO
CREATE VIEW [history].[ADDRESS_Current] AS
    SELECT 
           [ADDRESS.ID],	
           [RESIDENTS],	
           [ADDRESS.LINES],	
           [CITY],	
           [STATE],	
           [ZIP],	
           [COUNTY],	
           [CNTY.DESC],	
           [COUNTRY],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[ADDRESS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[APPLICATION_STATUSES_Current]
GO
CREATE VIEW [history].[APPLICATION_STATUSES_Current] AS
    SELECT 
           [APPLICATION.STATUSES.ID],	
           [APP.INTG.ADM.DEC.TYP.IDX],	
           [APPS.DESC],	
           [APPS.SPECIAL.PROCESSING.CODE],	
           [APPS.COLUMN.NO],	
           [APPS.USER1],	
           [APPS.USER2],	
           [APPS.USER3],	
           [APPS.USER4],	
           [APPS.USER5],	
           [APPS.USER6],	
           [APPS.USER7],	
           [APPS.USER8],	
           [APPS.USER9],	
           [APPS.USER10],	
           [APPLICATION.STATUSES.ADDOPR],	
           [APPLICATION.STATUSES.ADDDATE],	
           [APPLICATION.STATUSES.CHGOPR],	
           [APPLICATION.STATUSES.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[APPLICATION_STATUSES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[APPLICATIONS_Current]
GO
CREATE VIEW [history].[APPLICATIONS_Current] AS
    SELECT 
           [APPLICATIONS.ID],	
           [APPL.APPLICANT],	
           [APPL.FIRST.NAME],	
           [APPL.LAST.NAME],	
           [APPL.DATE],	
           [APPL.START.DATE],	
           [APPL.START.TERM],	
           [APPL.ACAD.PROGRAM],	
           [APPL.ACPG.TITLE],	
           [APPL.STU.LOAD.INTENT.DESC],	
           [APPL.ADMIT.STATUS],	
           [APPL.ADMIT.STATUS.DESC],	
           [APPL.CURRENT.STUDENT],	
           [APPL.ENROLLED],	
           [APPL.ADMIT.STATE],	
           [FPER.ALIEN.STATUS],	
           [STU.IMMIGRATION.STATUS],	
           [APPL.STATUS],	
           [APPL.STATUS.DATE],	
           [APPL.STATUS.TIME],	
           [APPLICATIONS.ADDOPR],	
           [APPLICATIONS.ADDDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[APPLICATIONS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[AR_INVOICE_ITEMS_Current]
GO
CREATE VIEW [history].[AR_INVOICE_ITEMS_Current] AS
    SELECT 
           [INV.NO],	
           [AR.INVOICE.ITEMS.ID],	
           [INV.PERSON.ID],	
           [INV.TERM],	
           [INVI.AR.CODE],	
           [INVI.AR.CATEGORY],	
           [INV.AR.TYPE],	
           [INVI.DESC],	
           [INVI.QTY],	
           [INVI.CHARGE.AMT],	
           [INVI.CR.AMT],	
           [INVI.EXT.CR.AMT],	
           [INVI.GL.CR.AMTS],	
           [INVI.GL.DR.AMTS],	
           [INV.AR.POSTED.FLAG],	
           [INV.LOCATION],	
           [INV.DATE],	
           [INVI.ADJ.TO.INVOICE.ITEM],	
           [INVI.ADJ.BY.INVOICE.ITEMS],	
           [INVI.APPLICATION],	
           [INVI.STU.MISC1],	
           [INVI.SEC.NAME],	
           [INVI.STUDENT.COURSE.SEC],	
           [AR.INVOICE.ITEMS.ADDDATE],	
           [AR.INVOICE.ITEMS.ADDTIME],	
           [AR.INVOICE.ITEMS.ADDOPR],	
           [AR.INVOICE.ITEMS.CHGDATE],	
           [AR.INVOICE.ITEMS.CHGTIME],	
           [AR.INVOICE.ITEMS.CHGOPR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[AR_INVOICE_ITEMS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[AR_PAYMENT_ITEMS_Current]
GO
CREATE VIEW [history].[AR_PAYMENT_ITEMS_Current] AS
    SELECT 
           [AR.PAYMENT.ITEMS.ID],	
           [AR.PERSON.ID],	
           [ARP.DATE],	
           [INVI.INVOICE],	
           [ARPI.INVOICE.ITEM],	
           [ARPI.AMT],	
           [ARPI.PAYMENT],	
           [ARPI.REVERSAL.AMT],	
           [XARPI.FAX.TA.AWARD],	
           [XARPI.FA.TRANSMITTAL],	
           [AR.PAYMENT.ITEMS.ADDDATE],	
           [AR.PAYMENT.ITEMS.ADDTIME],	
           [AR.PAYMENT.ITEMS.ADDOPR],	
           [AR.PAYMENT.ITEMS.CHGDATE],	
           [AR.PAYMENT.ITEMS.CHGTIME],	
           [AR.PAYMENT.ITEMS.CHGOPR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [ARPI.ALLOCATION.SOURCE]
      FROM [history].[AR_PAYMENT_ITEMS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[AWARDS_Current]
GO
CREATE VIEW [history].[AWARDS_Current] AS
    SELECT 
           [AW.ID],	
           [AW.AR.TYPE],	
           [AW.AWARD.AMT],	
           [AW.CATEGORY],	
           [AW.DESCRIPTION],	
           [AW.DESTINATION],	
           [AW.FEE.PERCENT],	
           [AW.DL.LOAN.TYPE],	
           [AW.NEED.COST],	
           [AW.PRIORITY],	
           [AW.SPONSORED.AWARD.FLAG],	
           [AW.TYPE],	
           [LOAN.FLAG],	
           [AWARDS.ADD.DATE],	
           [AWARDS.CHANGE.DATE],	
           [AWARDS.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[AWARDS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[CALENDAR_SCHEDULES_Current]
GO
CREATE VIEW [history].[CALENDAR_SCHEDULES_Current] AS
    SELECT 
           [CALENDAR.SCHEDULES.ID],	
           [CALS.ACAD.LEVEL],	
           [CALS.BLDG.ROOM.IDX],	
           [CALS.BUILDINGS],	
           [CALS.CAMPUS.CALENDAR],	
           [CALS.CLASSROOMS],	
           [CALS.COURSE.SEC.MEETING],	
           [CALS.CS.NAME],	
           [CALS.DATE],	
           [CALS.DATE.IDX],	
           [CALS.DAY],	
           [CALS.DESCRIPTION],	
           [CALS.END.TIME],	
           [CALS.EQUIPMENT],	
           [CALS.FACILITIES],	
           [CALS.LOCATION],	
           [CALS.PEOPLE],	
           [CALS.POINTER],	
           [CALS.REUSE.STAR],	
           [CALS.ROOMS],	
           [CALS.SCHEDULE.IDX],	
           [CALS.START.TIME],	
           [CALS.TYPE],	
           [CALENDAR.SCHEDULES.ADDOPR],	
           [CALENDAR.SCHEDULES.ADDDATE],	
           [CALENDAR.SCHEDULES.CHGOPR],	
           [CALENDAR.SCHEDULES.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[CALENDAR_SCHEDULES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[CIP_Current]
GO
CREATE VIEW [history].[CIP_Current] AS
    SELECT 
           [CIP.ID],	
           [CIP.DESC],	
           [CIP.FORMER.CODES],	
           [CIP.FORMER.YEAR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[CIP]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[COUNTIES_Current]
GO
CREATE VIEW [history].[COUNTIES_Current] AS
    SELECT 
           [COUNTIES.ID],	
           [CNTY.DESC],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[COUNTIES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[COUNTRIES_Current]
GO
CREATE VIEW [history].[COUNTRIES_Current] AS
    SELECT 
           [COUNTRIES.ID],	
           [CTRY.DESC],	
           [CTRY.ISO.CODE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[COUNTRIES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[COURSE_PROGRAMS_Current]
GO
CREATE VIEW [history].[COURSE_PROGRAMS_Current] AS
    SELECT 
           [COURSE.PROGRAMS.ID],	
           [CRS.NAME],	
           [CRSP.ACAD.PROGRAMS],	
           [CRSP.CATALOGS],	
           [COURSE.PROGRAMS.ADDOPR],	
           [COURSE.PROGRAMS.ADDDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[COURSE_PROGRAMS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[COURSE_SEC_FACULTY_Current]
GO
CREATE VIEW [history].[COURSE_SEC_FACULTY_Current] AS
    SELECT 
           [COURSE.SEC.FACULTY.ID],	
           [CSF.FACULTY],	
           [XCSF.FACULTY.FTE],	
           [CSF.FACULTY.LOAD],	
           [CSF.FACULTY.PCT],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [CSF.PAC.LP.ASGMT],	
           [CSF.INSTR.METHOD],	
           [XCSF.CONTRACT.NO]
      FROM [history].[COURSE_SEC_FACULTY]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[COURSE_SEC_MEETING_Current]
GO
CREATE VIEW [history].[COURSE_SEC_MEETING_Current] AS
    SELECT 
           [COURSE.SEC.MEETING.ID],	
           [CSM.SEC.TERM],	
           [CSM.BLDG],	
           [CSM.COURSE.SECTION],	
           [CSM.INSTR.METHOD],	
           [CSM.ROOM],	
           [CSM.ROOM.TYPE],	
           [CSM.DAYS],	
           [CSM.FREQUENCY],	
           [CSM.START.DATE],	
           [CSM.START.TIME],	
           [CSM.END.DATE],	
           [CSM.END.TIME],	
           [COURSE.SEC.MEETING.ADDDATE],	
           [COURSE.SEC.MEETING.ADDOPR],	
           [COURSE.SEC.MEETING.CHGDATE],	
           [COURSE.SEC.MEETING.CHGOPR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[COURSE_SEC_MEETING]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[COURSE_SECTIONS_Current]
GO
CREATE VIEW [history].[COURSE_SECTIONS_Current] AS
    SELECT 
           [COURSE.SECTIONS.ID],	
           [SEC.TERM],	
           [SEC.REPORTING.TERM],	
           [SEC.COURSE],	
           [SEC.NAME],	
           [SEC.NO],	
           [SEC.USER1],	
           [SEC.USER2],	
           [SEC.USER6],	
           [SEC.LOCATION],	
           [SEC.LOCATION.DESC.CC],	
           [SEC.CAPACITY],	
           [SEC.EVERY.STUDENT.COUNT],	
           [SEC.STUDENTS.COUNT],	
           [SEC.AUDIT.STUDENT.COUNT],	
           [SEC.ACAD.LEVEL],	
           [SEC.CRED.TYPE],	
           [SEC.MIN.CRED],	
           [SEC.MAX.CRED],	
           [SEC.BILLING.CRED],	
           [XSEC.FTE.COUNT],	
           [XSEC.FTE.CONTACT],	
           [SEC.CEUS],	
           [XSEC.FTE],	
           [X.842.CONED.FTE],	
           [SEC.FUNDING.SOURCES],	
           [SEC.FUNDING.ACCTG.METHOD],	
           [SEC.BILLING.METHOD],	
           [SEC.FEE],	
           [SEC.REVENUE],	
           [SEC.CONTACT.HOURS],	
           [SEC.CONTACT.MEASURES],	
           [SEC.FACULTY],	
           [SEC.COURSE.LEVELS],	
           [SEC.STUDENTS],	
           [SEC.STATUS.ACTION1],	
           [SEC.STATUS],	
           [COURSE.SECTIONS.ADDDATE],	
           [COURSE.SECTIONS.ADDOPR],	
           [COURSE.SECTIONS.CHGDATE],	
           [COURSE.SECTIONS.CHGOPR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [SEC.INSTR.METHODS],	
           [SEC.START.DATE],	
           [SEC.CENSUS.DATES],	
           [SEC.MEETING],	
           [SEC.END.DATE],	
           [X.SEC.DELIVERY.NCIH.FLAG],	
           [X.SEC.DELIVERY.MODIFIER],	
           [X.SEC.DELIVERY.METHOD],	
           [X.SEC.DELIVERY.MODE]
      FROM [history].[COURSE_SECTIONS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[COURSES_Current]
GO
CREATE VIEW [history].[COURSES_Current] AS
    SELECT 
           [COURSES.ID],	
           [CRS.NAME],	
           [CRS.SUBJECT],	
           [CRS.NO],	
           [CRS.TITLE],	
           [CRS.SHORT.TITLE],	
           [CRS.DESC],	
           [CRS.MIN.CRED],	
           [CRS.MAX.CRED],	
           [CRS.CEUS],	
           [CRS.CIP],	
           [CRS.SCHOOLS],	
           [CRS.DIVISIONS],	
           [CRS.COREQ.COURSES],	
           [CRS.COREQ.COURSES.REQD.FLAG],	
           [CRS.DEPTS],	
           [CRS.DEPT.PCTS],	
           [CRS.COURSE.TYPES],	
           [CRS.STATUS],	
           [CRS.STATUS.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[COURSES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[CRED_TYPES_Current]
GO
CREATE VIEW [history].[CRED_TYPES_Current] AS
    SELECT 
           [ID],	
           [CRTP.CATEGORY],	
           [CRTP.DESC],	
           [CRTP.ATT.CRED.FLAG],	
           [CRTP.CMPL.CRED.FLAG],	
           [CRTP.GPA.CRED.FLAG],	
           [CRTP.USER1],	
           [CRTP.USER2],	
           [CRTP.USER3],	
           [CRTP.USER4],	
           [CRTP.USER5],	
           [CRTP.USER6],	
           [CRTP.USER7],	
           [CRTP.USER8],	
           [CRTP.USER9],	
           [CRTP.USER10],	
           [CRED.TYPES.ADDOPR],	
           [CRED.TYPES.ADDDATE],	
           [CRED.TYPES.CHGOPR],	
           [CRED.TYPES.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[CRED_TYPES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[CS_ACYR_Current]
GO
CREATE VIEW [history].[CS_ACYR_Current] AS
    SELECT 
           [CS.STUDENT.ID],	
           [CS.YEAR],	
           [CS.AWARD],	
           [CS.FC],	
           [CS.VERIF.STATUS],	
           [CS.VERIF.DT],	
           [CS.VERIF.FLAGS],	
           [CS.HAS.ISIR],	
           [CS.ACYR.ADD.DATE],	
           [CS.ACYR.ADD.OPERATOR],	
           [CS.ACYR.CHANGE.DATE],	
           [CS.ACYR.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [CS.FED.ISIR.ID],	
           [CS.NEED],	
           [CS.FED.ISIR.OR.CORRECTION],	
           [CS.FED.ISIR.CORRECTION],	
           [CS.COMP.ID],	
           [CS.TOTAL.FAMILY.INCOME]
      FROM [history].[CS_ACYR]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[DEPTS_Current]
GO
CREATE VIEW [history].[DEPTS_Current] AS
    SELECT 
           [DEPTS.ID],	
           [DEPTS.INSTITUTIONS.ID],	
           [DEPTS.TYPE],	
           [DEPTS.SCHOOL],	
           [DEPTS.CIP],	
           [DEPTS.DESC],	
           [DEPTS.DESC.LKUP],	
           [DEPTS.TERMINAL.DEGREE],	
           [DEPTS.HEAD.ID],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [DEPTS.DIVISION]
      FROM [history].[DEPTS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[DIVISIONS_Current]
GO
CREATE VIEW [history].[DIVISIONS_Current] AS
    SELECT 
           [DIVISIONS.ID],	
           [DIV.DESC],	
           [DIV.INSTITUTIONS.ID],	
           [DIV.TYPE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[DIVISIONS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[ELF_TRANSLATE_TABLES_Current]
GO
CREATE VIEW [history].[ELF_TRANSLATE_TABLES_Current] AS
    SELECT 
           [ELF.TRANSLATE.TABLES.ID],	
           [ELFT.ACTION.CODES.1],	
           [ELFT.ACTION.CODES.2],	
           [ELFT.ACTION.CODES.3],	
           [ELFT.ACTION.CODES.4],	
           [ELFT.COMMENTS],	
           [ELFT.DESC],	
           [ELFT.NEW.CODE.FIELD],	
           [ELFT.NEW.CODES],	
           [ELFT.ORIG.CODE.FIELD],	
           [ELFT.ORIG.CODES],	
           [ELF.TRANSLATE.TABLES.ADDOPR],	
           [ELF.TRANSLATE.TABLES.ADDDATE],	
           [ELF.TRANSLATE.TABLES.CHGOPR],	
           [ELF.TRANSLATE.TABLES.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[ELF_TRANSLATE_TABLES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[ETHNICS_Current]
GO
CREATE VIEW [history].[ETHNICS_Current] AS
    SELECT 
           [ETHNICS.ID],	
           [ETH.DESC],	
           [ETHNICS.ADD.DATE],	
           [ETHNICS.ADD.OPERATOR],	
           [ETHNICS.CHANGE.DATE],	
           [ETHNICS.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[ETHNICS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[FA_TRANSMITTALS_Current]
GO
CREATE VIEW [history].[FA_TRANSMITTALS_Current] AS
    SELECT 
           [FA.TRANSMITTALS.ID],	
           [FAX.TA.STUDENT],	
           [FAX.STU.SORT.NAME],	
           [FAX.FA.YEAR],	
           [FAX.TA.TERM],	
           [FAX.TA.AWARD],	
           [FAX.TA.TERM.AMT],	
           [FAX.TA.D7.EXCESS.XMIT.AMT],	
           [FAX.TA.AMT.FLAG],	
           [FAX.TA.ELIG.FLAG],	
           [FAX.TA.TERM.ACTION],	
           [FAX.POSTING.DATE],	
           [FAX.POSTING.ARP.DATE],	
           [FAX.AR.PAYMENTS],	
           [FAX.FIRST.AR.PAYMENT],	
           [FAX.ELIG.CONNECTOR],	
           [FAX.ELIG.RULES],	
           [FAX.ELIG.SUBROUTINE],	
           [FAX.GL.REFERENCE.NO],	
           [FAX.GLOBAL.ELIG.FLAG],	
           [FAX.TA.ACYR],	
           [FAX.TA.ACYR.ID.IDX],	
           [FAX.TA.TERM.LOAN.FEES],	
           [FAX.TA.TERM.PRIORITY],	
           [FAX.TRANSMIT.ELIG.RULES],	
           [FAX.TRANSMITTAL.MODE],	
           [FAX.TRANSMITTAL.SUBROUTINE],	
           [FA.TRANSMITTALS.ADDOPR],	
           [FA.TRANSMITTALS.ADDDATE],	
           [FA.TRANSMITTALS.CHGOPR],	
           [FA.TRANSMITTALS.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[FA_TRANSMITTALS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[FACULTY_Current]
GO
CREATE VIEW [history].[FACULTY_Current] AS
    SELECT 
           [FACULTY.ID],	
           [FAC.FIRST.NAME],	
           [FAC.MIDDLE.NAME],	
           [FAC.LAST.NAME],	
           [FAC.NAME],	
           [FAC.SHORT.NAME],	
           [FAC.SORT.NAME],	
           [FAC.TENURE.TYPE],	
           [FAC.HRPER.FLAG],	
           [FAC.ADVISE.FLAG],	
           [FAC.DIVISIONS],	
           [FAC.DEPTS],	
           [FAC.DEPT.PCTS],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[FACULTY]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[FNDSRC_Current]
GO
CREATE VIEW [history].[FNDSRC_Current] AS
    SELECT 
           [FNDSRC.ID],	
           [FNDSRC.ACCT.PIECE],	
           [FNDSRC.ACCT.VALUE],	
           [FNDSRC.ACTIVE.FLAG],	
           [FNDSRC.DESC],	
           [FNDSRC.DESC.IDX],	
           [FNDSRC.GL.NO],	
           [FNDSRC.TYPE],	
           [FNDSRC.ADD.OPERATOR],	
           [FNDSRC.ADD.DATE],	
           [FNDSRC.CHANGE.OPERATOR],	
           [FNDSRC.CHANGE.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[FNDSRC]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[FOREIGN_PERSON_Current]
GO
CREATE VIEW [history].[FOREIGN_PERSON_Current] AS
    SELECT 
           [FOREIGN.PERSON.ID],	
           [FPER.ALIEN.STATUS],	
           [FPER.IMMIGRATION.STATUS],	
           [FPER.REG.NO],	
           [FPER.BIRTH.CITY],	
           [FPER.BIRTH.COUNTRY],	
           [FPER.COUNTRY.ENTRY.DATE],	
           [FPER.FORMS],	
           [FPER.VISA.ISSUE.POST],	
           [FPER.FUNDING.SOURCES],	
           [FPER.I94.NO],	
           [FPER.NATIVE.LANGUAGE],	
           [FPER.OTHER.LANGUAGES],	
           [FPER.PASSPORT.COUNTRY],	
           [FPER.PASSPORT.EXPIRE.DATE],	
           [FPER.PASSPORT.NO],	
           [FPER.PORT.OF.ENTRY],	
           [FPER.RESIDENCE.COUNTRY],	
           [FPER.VISA.ISSUE.COUNTRY],	
           [FPER.VISA.NO],	
           [FPER.VISA.TYPE],	
           [FPER.VISA.ISSUE.DATE],	
           [FPER.VISA.EXPIRE.DATE],	
           [FOREIGN.PERSON.ADDOPR],	
           [FOREIGN.PERSON.ADDDATE],	
           [FOREIGN.PERSON.CHGOPR],	
           [FOREIGN.PERSON.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[FOREIGN_PERSON]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[GRADES_Current]
GO
CREATE VIEW [history].[GRADES_Current] AS
    SELECT 
           [GRADES.ID],	
           [GRD.GRADE],	
           [GRD.LEGEND],	
           [GRD.GRADE.SCHEME],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [GRD.REPL.CMPL.CRED.FLAG],	
           [GRD.REPL.GPA.CRED.FLAG],	
           [GRD.CMPL.CRED.FLAG],	
           [GRD.PASS.NOPASS.GRADE],	
           [GRD.ATT.CRED.FLAG],	
           [GRD.EXCLUDE.FROM.FAC.FLAG],	
           [GRD.FINAL.REQUIRE.LDA],	
           [GRD.REPEAT.VALUE],	
           [GRD.USE.AFTER.DROP.GRD.REQD],	
           [GRD.COMPARISON.GRADE],	
           [GRD.AUDIT.GRADE],	
           [GRD.INCOMPLETE.GRADE],	
           [GRD.USE.IN.FINAL.GRD.LIST],	
           [GRD.GPA.CRED.FLAG],	
           [GRD.WITHDRAW.GRADE],	
           [GRD.USE.IN.MIDTERM.GRD.LIST],	
           [GRD.VALUE],	
           [GRD.REPL.ATT.CRED.FLAG]
      FROM [history].[GRADES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[HRPER_Current]
GO
CREATE VIEW [history].[HRPER_Current] AS
    SELECT 
           [HRPER.ID],	
           [HRP.FIRST.NAME],	
           [HRP.MIDDLE.NAME],	
           [HRP.LAST.NAME],	
           [HRP.MAIDEN.LAST.NAME],	
           [HRP.NICKNAME],	
           [HRP.PREFIX],	
           [HRP.SUFFIX],	
           [HRP.BIRTH.DATE],	
           [HRP.DECEASED.DATE],	
           [HRP.MARITAL.STATUS],	
           [HRP.PERSTAT.START.DATE],	
           [HRP.PERSTAT.END.DATE],	
           [HRP.PERPOS.START.DATE],	
           [HRP.PERPOS.END.DATE],	
           [HRP.PERLV.START.DATE],	
           [HRP.PERLV.END.DATE],	
           [HRP.LAST.PERIOD.PAID],	
           [HRP.PERPOS.LAST.PAY.DATE],	
           [HRP.PERLV.LAST.PAY.DATE],	
           [HRP.EFFECT.EMPLOY.DATE],	
           [HRP.EFFECT.TERM.DATE],	
           [HRP.SERVICE.YEARS],	
           [HRP.SERVICE.MONTHS],	
           [X842.SERVICE.YEARS],	
           [X842.SERVICE.YEARS2],	
           [X.842.IS.FACULTY],	
           [HRP.ACTIVE.STATUS],	
           [HRP.CURRENT.STATUS],	
           [HRP.PERSTAT.STATUS],	
           [X.ACTIVE.STATUS],	
           [HRP.ADR.LINES],	
           [HRP.ADR.CITY],	
           [HRP.ADR.STATE],	
           [HRP.ADR.ZIP],	
           [HRP.PRI.DEPT1],	
           [HRP.PRI.DEPT.DESC],	
           [XHRP.XNC.ACAD.LEVEL],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [HRP.SEX],	
           [HRP.PRI.POS],	
           [HRP.ANNIVERSARY.DAY],	
           [HRP.PERPOS.POSITION.ID],	
           [HRP.PRIVACY.FLAG]
      FROM [history].[HRPER]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[INSTITUTIONS_Current]
GO
CREATE VIEW [history].[INSTITUTIONS_Current] AS
    SELECT 
           [INSTITUTIONS.ID],	
           [INST.SORT.NAME],	
           [INST.TYPE],	
           [CORP.FICE],	
           [INST.CEEB],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[INSTITUTIONS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[INSTITUTIONS_ATTEND_Current]
GO
CREATE VIEW [history].[INSTITUTIONS_ATTEND_Current] AS
    SELECT 
           [INSTA.INSTITUTIONS.ID],	
           [INSTA.PERSON.ID],	
           [INSTA.START.DATES],	
           [INSTA.END.DATES],	
           [INSTA.ACAD.CREDENTIALS],	
           [X.INSTA.INSTITUTION],	
           [INSTA.INST.TYPE],	
           [X.INSTA.842.ADR.STATE],	
           [X.INSTA.842.PREF.CITY],	
           [INSTA.GRAD.TYPE],	
           [INSTA.TRANSCRIPT.STATUS],	
           [INSTA.TRANSCRIPT.DATE],	
           [INSTA.TRANSCRIPT.TYPE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [INSTA.RANK.DENOMINATOR],	
           [INSTA.RANK.NUMERATOR],	
           [INSTA.YEAR.ATTEND.END],	
           [INSTA.RANK.PERCENT],	
           [INSTA.EXT.GPA],	
           [INSTA.YEAR.ATTEND.START]
      FROM [history].[INSTITUTIONS_ATTEND]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[ISIR_FAFSA_Current]
GO
CREATE VIEW [history].[ISIR_FAFSA_Current] AS
    SELECT 
           [ISIR.FAFSA.ID],	
           [IFAF.STUDENT.ID],	
           [IFAF.IMPORT.YEAR],	
           [IFAF.DATE.SIGN],	
           [IFAF.RECEIPT.DT],	
           [IFAF.ISIR.TYPE],	
           [IFAF.S.AGI],	
           [IFAF.P.AGI],	
           [IFAF.PRI.EFC],	
           [IFAF.S.MARITAL.ST],	
           [IFAF.P.MARITAL.ST],	
           [IFAF.DEPENDENCY],	
           [IFAF.DEPEND.CHILDREN],	
           [IFAF.FATHER.GRADE.LVL],	
           [IFAF.MOTHER.GRADE.LVL],	
           [IFAF.TITLEIV.1],	
           [IFAF.TITLEIV.2],	
           [IFAF.TITLEIV.3],	
           [IFAF.TITLEIV.4],	
           [IFAF.TITLEIV.5],	
           [IFAF.TITLEIV.6],	
           [IFAF.TITLEIV.7],	
           [IFAF.TITLEIV.8],	
           [IFAF.TITLEIV.9],	
           [IFAF.TITLEIV.10],	
           [IFAF.CORR.STATUS],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [IFAF.FATHER.FIRST],	
           [IFAF.MOTHER.FIRST],	
           [IFAF.FATHER.LAST],	
           [IFAF.MOTHER.DOB],	
           [IFAF.FATHER.DOB],	
           [IFAF.MOTHER.LAST],	
           [IFAF.TRANS.RECEIPT.DT]
      FROM [history].[ISIR_FAFSA]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[MAJORS_Current]
GO
CREATE VIEW [history].[MAJORS_Current] AS
    SELECT 
           [MAJORS.ID],	
           [MAJ.ACTIVE.FLAG],	
           [MAJ.CIP],	
           [MAJ.DESC],	
           [MAJ.DIVISION],	
           [MAJORS.ADDDATE],	
           [MAJORS.ADDOPR],	
           [MAJORS.CHGDATE],	
           [MAJORS.CHGOPR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[MAJORS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__ALL_CDD_Current]
GO
CREATE VIEW [history].[META__ALL_CDD_Current] AS
    SELECT 
           [CDDFILE],	
           [DATA.ELEMENT],	
           [COMPUTED.COLUMN.CODE],	
           [CONVERTED.FROM],	
           [DATA.TYPE],	
           [DATABASE.USAGE.TYPE],	
           [DEFAULT.DISPLAY.SECURE],	
           [DEFAULT.DISPLAY.SIZE],	
           [DEFAULT.INPUT.PROMPT],	
           [DEFAULT.SAMPLE.DATA],	
           [DEFAULT.ZERO.PAD],	
           [DERIVED.SEC.PTR],	
           [DT1],	
           [DT2],	
           [DT3],	
           [DT4],	
           [DT5],	
           [ELEMENT.ASSOC.NAME],	
           [ELEMENT.ASSOC.TYPE],	
           [ELEMENT.POINTED.FROM],	
           [ELEMENT.POINTED.TO],	
           [FIELD.PLACEMENT],	
           [INFORM.CONVERSION.STRING],	
           [INFORM.FORMAT.STRING],	
           [MAXIMUM.STORAGE.SIZE],	
           [PURPOSE],	
           [REPORT.HEADER],	
           [SOURCE],	
           [TRUNCATION.FLAG],	
           [VALIDATION.TABLE],	
           [TOOLCDD.ADD.DATE],	
           [TOOLCDD.ADD.OPERATOR],	
           [TOOLCDD.CHANGE.DATE],	
           [TOOLCDD.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__ALL_CDD]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__CF_CDD_Current]
GO
CREATE VIEW [history].[META__CF_CDD_Current] AS
    SELECT 
           [DATA.ELEMENT],	
           [COMPUTED.COLUMN.CODE],	
           [CONVERTED.FROM],	
           [DATA.TYPE],	
           [DATABASE.USAGE.TYPE],	
           [DEFAULT.DISPLAY.SECURE],	
           [DEFAULT.DISPLAY.SIZE],	
           [DEFAULT.INPUT.PROMPT],	
           [DEFAULT.SAMPLE.DATA],	
           [DEFAULT.ZERO.PAD],	
           [DERIVED.SEC.PTR],	
           [DT1],	
           [DT2],	
           [DT3],	
           [DT4],	
           [DT5],	
           [ELEMENT.ASSOC.NAME],	
           [ELEMENT.ASSOC.TYPE],	
           [ELEMENT.POINTED.FROM],	
           [ELEMENT.POINTED.TO],	
           [FIELD.PLACEMENT],	
           [INFORM.CONVERSION.STRING],	
           [INFORM.FORMAT.STRING],	
           [MAXIMUM.STORAGE.SIZE],	
           [PURPOSE],	
           [REPORT.HEADER],	
           [SOURCE],	
           [TRUNCATION.FLAG],	
           [VALIDATION.TABLE],	
           [TOOLCDD.ADD.DATE],	
           [TOOLCDD.ADD.OPERATOR],	
           [TOOLCDD.CHANGE.DATE],	
           [TOOLCDD.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__CF_CDD]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__CF_SECLASS_Current]
GO
CREATE VIEW [history].[META__CF_SECLASS_Current] AS
    SELECT 
           [SYS.CLASS.ID],	
           [SYS.CLASS.DESCRIPTION],	
           [LIMITED.TO.PROCESS.LIST],	
           [LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],	
           [INQUIRY.ONLY.PROCESS.LIST],	
           [INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],	
           [DENY.ACCESS.EXCEPT.TO.CLASS],	
           [DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__CF_SECLASS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__CF_VALCODES_Current]
GO
CREATE VIEW [history].[META__CF_VALCODES_Current] AS
    SELECT 
           [VALCODE.ID],	
           [VAL.PURPOSE],	
           [VAL.ACTION.CODE.1],	
           [VAL.ACTION.CODE.2],	
           [VAL.ACTION.CODE.3],	
           [VAL.ACTION.CODE.4],	
           [VAL.CODE.LENGTH],	
           [VAL.EXTERNAL.REPRESENTATION],	
           [VAL.INTERNAL.CODE],	
           [VAL.MINIMUM.INPUT.STRING],	
           [VAL.NO.MOD],	
           [VAL.ZERO.FILL],	
           [VALCODES.MODULES],	
           [VALCODES.RELEASE.STATUS],	
           [VAL.APPLICATION],	
           [VALCODES.ADD.OPERATOR],	
           [VALCODES.ADD.DATE],	
           [VALCODES.CHANGE.OPERATOR],	
           [VALCODES.CHANGE.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__CF_VALCODES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__CORE_CDD_Current]
GO
CREATE VIEW [history].[META__CORE_CDD_Current] AS
    SELECT 
           [DATA.ELEMENT],	
           [COMPUTED.COLUMN.CODE],	
           [CONVERTED.FROM],	
           [DATA.TYPE],	
           [DATABASE.USAGE.TYPE],	
           [DEFAULT.DISPLAY.SECURE],	
           [DEFAULT.DISPLAY.SIZE],	
           [DEFAULT.INPUT.PROMPT],	
           [DEFAULT.SAMPLE.DATA],	
           [DEFAULT.ZERO.PAD],	
           [DERIVED.SEC.PTR],	
           [DT1],	
           [DT2],	
           [DT3],	
           [DT4],	
           [DT5],	
           [ELEMENT.ASSOC.NAME],	
           [ELEMENT.ASSOC.TYPE],	
           [ELEMENT.POINTED.FROM],	
           [ELEMENT.POINTED.TO],	
           [FIELD.PLACEMENT],	
           [INFORM.CONVERSION.STRING],	
           [INFORM.FORMAT.STRING],	
           [MAXIMUM.STORAGE.SIZE],	
           [PURPOSE],	
           [REPORT.HEADER],	
           [SOURCE],	
           [TRUNCATION.FLAG],	
           [VALIDATION.TABLE],	
           [TOOLCDD.ADD.DATE],	
           [TOOLCDD.ADD.OPERATOR],	
           [TOOLCDD.CHANGE.DATE],	
           [TOOLCDD.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__CORE_CDD]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__CORE_SECLASS_Current]
GO
CREATE VIEW [history].[META__CORE_SECLASS_Current] AS
    SELECT 
           [SYS.CLASS.ID],	
           [SYS.CLASS.DESCRIPTION],	
           [LIMITED.TO.PROCESS.LIST],	
           [LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],	
           [INQUIRY.ONLY.PROCESS.LIST],	
           [INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],	
           [DENY.ACCESS.EXCEPT.TO.CLASS],	
           [DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__CORE_SECLASS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__CORE_VALCODES_Current]
GO
CREATE VIEW [history].[META__CORE_VALCODES_Current] AS
    SELECT 
           [VALCODE.ID],	
           [VAL.PURPOSE],	
           [VAL.ACTION.CODE.1],	
           [VAL.ACTION.CODE.2],	
           [VAL.ACTION.CODE.3],	
           [VAL.ACTION.CODE.4],	
           [VAL.CODE.LENGTH],	
           [VAL.EXTERNAL.REPRESENTATION],	
           [VAL.INTERNAL.CODE],	
           [VAL.MINIMUM.INPUT.STRING],	
           [VAL.NO.MOD],	
           [VAL.ZERO.FILL],	
           [VALCODES.MODULES],	
           [VALCODES.RELEASE.STATUS],	
           [VAL.APPLICATION],	
           [VALCODES.ADD.OPERATOR],	
           [VALCODES.ADD.DATE],	
           [VALCODES.CHANGE.OPERATOR],	
           [VALCODES.CHANGE.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__CORE_VALCODES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__HR_CDD_Current]
GO
CREATE VIEW [history].[META__HR_CDD_Current] AS
    SELECT 
           [DATA.ELEMENT],	
           [COMPUTED.COLUMN.CODE],	
           [CONVERTED.FROM],	
           [DATA.TYPE],	
           [DATABASE.USAGE.TYPE],	
           [DEFAULT.DISPLAY.SECURE],	
           [DEFAULT.DISPLAY.SIZE],	
           [DEFAULT.INPUT.PROMPT],	
           [DEFAULT.SAMPLE.DATA],	
           [DEFAULT.ZERO.PAD],	
           [DERIVED.SEC.PTR],	
           [DT1],	
           [DT2],	
           [DT3],	
           [DT4],	
           [DT5],	
           [ELEMENT.ASSOC.NAME],	
           [ELEMENT.ASSOC.TYPE],	
           [ELEMENT.POINTED.FROM],	
           [ELEMENT.POINTED.TO],	
           [FIELD.PLACEMENT],	
           [INFORM.CONVERSION.STRING],	
           [INFORM.FORMAT.STRING],	
           [MAXIMUM.STORAGE.SIZE],	
           [PURPOSE],	
           [REPORT.HEADER],	
           [SOURCE],	
           [TRUNCATION.FLAG],	
           [VALIDATION.TABLE],	
           [TOOLCDD.ADD.DATE],	
           [TOOLCDD.ADD.OPERATOR],	
           [TOOLCDD.CHANGE.DATE],	
           [TOOLCDD.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__HR_CDD]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__HR_SECLASS_Current]
GO
CREATE VIEW [history].[META__HR_SECLASS_Current] AS
    SELECT 
           [SYS.CLASS.ID],	
           [SYS.CLASS.DESCRIPTION],	
           [LIMITED.TO.PROCESS.LIST],	
           [LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],	
           [INQUIRY.ONLY.PROCESS.LIST],	
           [INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],	
           [DENY.ACCESS.EXCEPT.TO.CLASS],	
           [DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__HR_SECLASS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__HR_VALCODES_Current]
GO
CREATE VIEW [history].[META__HR_VALCODES_Current] AS
    SELECT 
           [VALCODE.ID],	
           [VAL.PURPOSE],	
           [VAL.ACTION.CODE.1],	
           [VAL.ACTION.CODE.2],	
           [VAL.ACTION.CODE.3],	
           [VAL.ACTION.CODE.4],	
           [VAL.CODE.LENGTH],	
           [VAL.EXTERNAL.REPRESENTATION],	
           [VAL.INTERNAL.CODE],	
           [VAL.MINIMUM.INPUT.STRING],	
           [VAL.NO.MOD],	
           [VAL.ZERO.FILL],	
           [VALCODES.MODULES],	
           [VALCODES.RELEASE.STATUS],	
           [VAL.APPLICATION],	
           [VALCODES.ADD.OPERATOR],	
           [VALCODES.ADD.DATE],	
           [VALCODES.CHANGE.OPERATOR],	
           [VALCODES.CHANGE.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__HR_VALCODES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__RT_FIELDS_Current]
GO
CREATE VIEW [history].[META__RT_FIELDS_Current] AS
    SELECT 
           [RT.FIELDS.ID],	
           [RT.FIELDS.ADD.DATE],	
           [RT.FIELDS.ADD.OPERATOR],	
           [RT.FIELDS.CHANGE.DATE],	
           [RT.FIELDS.CHANGE.OPERATOR],	
           [RT.FILES.INTER.FILE.FLAG],	
           [RTFLDS.ALT.DICT.NAME],	
           [RTFLDS.ASSOCIATION],	
           [RTFLDS.AUTO.XREF.FILES],	
           [RTFLDS.AUTO.XREF.KEYS],	
           [RTFLDS.CONVERSION],	
           [RTFLDS.CONVERT.TO.UPPER],	
           [RTFLDS.DATABASE.USAGE.TYPE],	
           [RTFLDS.DEFAULT.HOOK],	
           [RTFLDS.DEFAULT.PROMPT],	
           [RTFLDS.DEFAULT.VALUE],	
           [RTFLDS.DEMAND.FIELDS],	
           [RTFLDS.DESCRIPTION],	
           [RTFLDS.END.POS],	
           [RTFLDS.FIELD.NUMBER],	
           [RTFLDS.FILE.NAME],	
           [RTFLDS.FORMAT],	
           [RTFLDS.INPUT.EDITING.HOOK],	
           [RTFLDS.INPUT.TRUNCATION],	
           [RTFLDS.JUSTIFICATION],	
           [RTFLDS.LENGTH],	
           [RTFLDS.MANDATORY.FIELD],	
           [RTFLDS.MAX.RANGE],	
           [RTFLDS.MAX.STORAGE.LENGTH],	
           [RTFLDS.MAX.VALUES],	
           [RTFLDS.MIN.RANGE],	
           [RTFLDS.OUTPUT.EDITING.HOOK],	
           [RTFLDS.OUTPUT.ERROR.FLAG],	
           [RTFLDS.OUTPUT.ERROR.MSG],	
           [RTFLDS.OUTPUT.FILL.CHAR],	
           [RTFLDS.OUTPUT.MASK],	
           [RTFLDS.PATTERN.MATCH],	
           [RTFLDS.PERM.INIT.HOOK],	
           [RTFLDS.READ.EDIT.HOOK],	
           [RTFLDS.READ.ICONV],	
           [RTFLDS.READ.REMOVE.CHARS],	
           [RTFLDS.READ.TRANSLATE.ACTION],	
           [RTFLDS.READ.TRANSLATE.TABLE],	
           [RTFLDS.READ.TRIM],	
           [RTFLDS.READ.TRIM.ZEROES],	
           [RTFLDS.RELATION.FIELD],	
           [RTFLDS.RELATION.FILE],	
           [RTFLDS.RELATION.KEY.HOOK],	
           [RTFLDS.REPORT.NAME],	
           [RTFLDS.SECONDARY.POINTER],	
           [RTFLDS.START.POS],	
           [RTFLDS.SUBR.ARGS.POINTERS],	
           [RTFLDS.SUBROUTINE.ARGS],	
           [RTFLDS.SUBROUTINE.NAME],	
           [RTFLDS.UC.WORD],	
           [RTFLDS.VAL.TABLE.APPLICATION],	
           [RTFLDS.VALIDATION.FIELD],	
           [RTFLDS.VALIDATION.FILE],	
           [RTFLDS.VALIDATION.HOOK],	
           [RTFLDS.VALIDATION.REQUIRED],	
           [RTFLDS.VALIDATION.TABLE],	
           [RTFLDS.VIRTUAL.FIELD.DEF],	
           [RTFLDS.WRITE.EDIT.HOOK],	
           [RTFLDS.WRITE.FORMAT],	
           [RTFLDS.WRITE.TRIM],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__RT_FIELDS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__ST_CDD_Current]
GO
CREATE VIEW [history].[META__ST_CDD_Current] AS
    SELECT 
           [DATA.ELEMENT],	
           [COMPUTED.COLUMN.CODE],	
           [CONVERTED.FROM],	
           [DATA.TYPE],	
           [DATABASE.USAGE.TYPE],	
           [DEFAULT.DISPLAY.SECURE],	
           [DEFAULT.DISPLAY.SIZE],	
           [DEFAULT.INPUT.PROMPT],	
           [DEFAULT.SAMPLE.DATA],	
           [DEFAULT.ZERO.PAD],	
           [DERIVED.SEC.PTR],	
           [DT1],	
           [DT2],	
           [DT3],	
           [DT4],	
           [DT5],	
           [ELEMENT.ASSOC.NAME],	
           [ELEMENT.ASSOC.TYPE],	
           [ELEMENT.POINTED.FROM],	
           [ELEMENT.POINTED.TO],	
           [FIELD.PLACEMENT],	
           [INFORM.CONVERSION.STRING],	
           [INFORM.FORMAT.STRING],	
           [MAXIMUM.STORAGE.SIZE],	
           [PURPOSE],	
           [REPORT.HEADER],	
           [SOURCE],	
           [TRUNCATION.FLAG],	
           [VALIDATION.TABLE],	
           [TOOLCDD.ADD.DATE],	
           [TOOLCDD.ADD.OPERATOR],	
           [TOOLCDD.CHANGE.DATE],	
           [TOOLCDD.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__ST_CDD]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__ST_SECLASS_Current]
GO
CREATE VIEW [history].[META__ST_SECLASS_Current] AS
    SELECT 
           [SYS.CLASS.ID],	
           [SYS.CLASS.DESCRIPTION],	
           [LIMITED.TO.PROCESS.LIST],	
           [LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],	
           [INQUIRY.ONLY.PROCESS.LIST],	
           [INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],	
           [DENY.ACCESS.EXCEPT.TO.CLASS],	
           [DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__ST_SECLASS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__ST_VALCODES_Current]
GO
CREATE VIEW [history].[META__ST_VALCODES_Current] AS
    SELECT 
           [VALCODE.ID],	
           [VAL.PURPOSE],	
           [VAL.ACTION.CODE.1],	
           [VAL.ACTION.CODE.2],	
           [VAL.ACTION.CODE.3],	
           [VAL.ACTION.CODE.4],	
           [VAL.CODE.LENGTH],	
           [VAL.EXTERNAL.REPRESENTATION],	
           [VAL.INTERNAL.CODE],	
           [VAL.MINIMUM.INPUT.STRING],	
           [VAL.NO.MOD],	
           [VAL.ZERO.FILL],	
           [VALCODES.MODULES],	
           [VALCODES.RELEASE.STATUS],	
           [VAL.APPLICATION],	
           [VALCODES.ADD.OPERATOR],	
           [VALCODES.ADD.DATE],	
           [VALCODES.CHANGE.OPERATOR],	
           [VALCODES.CHANGE.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__ST_VALCODES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__TOOL_CDD_Current]
GO
CREATE VIEW [history].[META__TOOL_CDD_Current] AS
    SELECT 
           [DATA.ELEMENT],	
           [COMPUTED.COLUMN.CODE],	
           [CONVERTED.FROM],	
           [DATA.TYPE],	
           [DATABASE.USAGE.TYPE],	
           [DEFAULT.DISPLAY.SECURE],	
           [DEFAULT.DISPLAY.SIZE],	
           [DEFAULT.INPUT.PROMPT],	
           [DEFAULT.SAMPLE.DATA],	
           [DEFAULT.ZERO.PAD],	
           [DERIVED.SEC.PTR],	
           [DT1],	
           [DT2],	
           [DT3],	
           [DT4],	
           [DT5],	
           [ELEMENT.ASSOC.NAME],	
           [ELEMENT.ASSOC.TYPE],	
           [ELEMENT.POINTED.FROM],	
           [ELEMENT.POINTED.TO],	
           [FIELD.PLACEMENT],	
           [INFORM.CONVERSION.STRING],	
           [INFORM.FORMAT.STRING],	
           [MAXIMUM.STORAGE.SIZE],	
           [PURPOSE],	
           [REPORT.HEADER],	
           [SOURCE],	
           [TRUNCATION.FLAG],	
           [VALIDATION.TABLE],	
           [TOOLCDD.ADD.DATE],	
           [TOOLCDD.ADD.OPERATOR],	
           [TOOLCDD.CHANGE.DATE],	
           [TOOLCDD.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__TOOL_CDD]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__TOOL_VALCODES_Current]
GO
CREATE VIEW [history].[META__TOOL_VALCODES_Current] AS
    SELECT 
           [VALCODE.ID],	
           [VAL.PURPOSE],	
           [VAL.ACTION.CODE.1],	
           [VAL.ACTION.CODE.2],	
           [VAL.ACTION.CODE.3],	
           [VAL.ACTION.CODE.4],	
           [VAL.CODE.LENGTH],	
           [VAL.EXTERNAL.REPRESENTATION],	
           [VAL.INTERNAL.CODE],	
           [VAL.MINIMUM.INPUT.STRING],	
           [VAL.NO.MOD],	
           [VAL.ZERO.FILL],	
           [VALCODES.MODULES],	
           [VALCODES.RELEASE.STATUS],	
           [VAL.APPLICATION],	
           [VALCODES.ADD.OPERATOR],	
           [VALCODES.ADD.DATE],	
           [VALCODES.CHANGE.OPERATOR],	
           [VALCODES.CHANGE.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__TOOL_VALCODES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__UT_CDD_Current]
GO
CREATE VIEW [history].[META__UT_CDD_Current] AS
    SELECT 
           [DATA.ELEMENT],	
           [COMPUTED.COLUMN.CODE],	
           [CONVERTED.FROM],	
           [DATA.TYPE],	
           [DATABASE.USAGE.TYPE],	
           [DEFAULT.DISPLAY.SECURE],	
           [DEFAULT.DISPLAY.SIZE],	
           [DEFAULT.INPUT.PROMPT],	
           [DEFAULT.SAMPLE.DATA],	
           [DEFAULT.ZERO.PAD],	
           [DERIVED.SEC.PTR],	
           [DT1],	
           [DT2],	
           [DT3],	
           [DT4],	
           [DT5],	
           [ELEMENT.ASSOC.NAME],	
           [ELEMENT.ASSOC.TYPE],	
           [ELEMENT.POINTED.FROM],	
           [ELEMENT.POINTED.TO],	
           [FIELD.PLACEMENT],	
           [INFORM.CONVERSION.STRING],	
           [INFORM.FORMAT.STRING],	
           [MAXIMUM.STORAGE.SIZE],	
           [PURPOSE],	
           [REPORT.HEADER],	
           [SOURCE],	
           [TRUNCATION.FLAG],	
           [VALIDATION.TABLE],	
           [TOOLCDD.ADD.DATE],	
           [TOOLCDD.ADD.OPERATOR],	
           [TOOLCDD.CHANGE.DATE],	
           [TOOLCDD.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__UT_CDD]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__UT_OPERS_Current]
GO
CREATE VIEW [history].[META__UT_OPERS_Current] AS
    SELECT 
           [SYS.PERSON.ID],	
           [SYS.USER.ID],	
           [SYS.USER.CLASSES],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__UT_OPERS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__UT_SECLASS_Current]
GO
CREATE VIEW [history].[META__UT_SECLASS_Current] AS
    SELECT 
           [SYS.CLASS.ID],	
           [SYS.CLASS.DESCRIPTION],	
           [LIMITED.TO.PROCESS.LIST],	
           [LIMITED.TO.PROCESS.LIST_PROCESS.DESCRIPTION],	
           [INQUIRY.ONLY.PROCESS.LIST],	
           [INQUIRY.ONLY.PROCESS.LIST_PROCESS.DESCRIPTION],	
           [DENY.ACCESS.EXCEPT.TO.CLASS],	
           [DENY.ACCESS.EXCEPT.TO.CLASS_PROCESS.DESCRIPTION],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__UT_SECLASS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[META__UT_VALCODES_Current]
GO
CREATE VIEW [history].[META__UT_VALCODES_Current] AS
    SELECT 
           [VALCODE.ID],	
           [VAL.PURPOSE],	
           [VAL.ACTION.CODE.1],	
           [VAL.ACTION.CODE.2],	
           [VAL.ACTION.CODE.3],	
           [VAL.ACTION.CODE.4],	
           [VAL.CODE.LENGTH],	
           [VAL.EXTERNAL.REPRESENTATION],	
           [VAL.INTERNAL.CODE],	
           [VAL.MINIMUM.INPUT.STRING],	
           [VAL.NO.MOD],	
           [VAL.ZERO.FILL],	
           [VALCODES.MODULES],	
           [VALCODES.RELEASE.STATUS],	
           [VAL.APPLICATION],	
           [VALCODES.ADD.OPERATOR],	
           [VALCODES.ADD.DATE],	
           [VALCODES.CHANGE.OPERATOR],	
           [VALCODES.CHANGE.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[META__UT_VALCODES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[N99_STU_SEC_ATTEND_Current]
GO
CREATE VIEW [history].[N99_STU_SEC_ATTEND_Current] AS
    SELECT 
           [N99.STU.SEC.ATTEND.ID],	
           [N99SA.COURSE.SECTION],	
           [N99SA.TERM],	
           [N99SA.STUDENT.ID],	
           [N99SA.STUDENT.COURSE.SEC],	
           [N99SA.COURSE.SEC.MEETING],	
           [N99SA.SEC.NAME],	
           [N99SA.COURSE],	
           [N99SA.ATTEND.DATE],	
           [N99SA.ATTEND.HOURS],	
           [N99SA.ATTEND.TYPE],	
           [N99SA.ALL.FACULTY],	
           [N99SA.ATTEND.CHNGD.DATE],	
           [N99SA.ATTEND.CHNGD.PERSON.ID],	
           [N99SA.ATTEND.CHNGD.VALUE],	
           [N99SA.ATTEND.COMMENTS],	
           [N99SA.EDATE.IDX],	
           [N99SA.ESIGNATURE],	
           [N99SA.FINAL.ESIGNATURE],	
           [N99SA.FINAL.ESIGNATURE.DATE],	
           [N99SA.LDATE.IDX],	
           [N99SA.LOCATION],	
           [N99SA.STU.DATE.IDX],	
           [N99.STU.SEC.ATTEND.ADDDATE],	
           [N99.STU.SEC.ATTEND.ADDOPR],	
           [N99.STU.SEC.ATTEND.CHGDATE],	
           [N99.STU.SEC.ATTEND.CHGOPR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[N99_STU_SEC_ATTEND]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[NON_COURSES_Current]
GO
CREATE VIEW [history].[NON_COURSES_Current] AS
    SELECT 
           [NON.COURSES.ID],	
           [NCRS.DESC],	
           [NCRS.SHORT.TITLE],	
           [NCRS.CAT.DESC.CC],	
           [NCRS.DESIRED.GRADES],	
           [NCRS.GRADE.SCHEME],	
           [NCRS.DESIRED.SCORE],	
           [NCRS.COURSE.EQUIVS],	
           [NCRS.MIN.SCORE],	
           [NCRS.MAX.SCORE],	
           [NCRS.TYPE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[NON_COURSES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[ORG_ENTITY_Current]
GO
CREATE VIEW [history].[ORG_ENTITY_Current] AS
    SELECT 
           [ORG.ENTITY.ID],	
           [OEE.USERNAME],	
           [OE.PREFIX],	
           [OE.FIRST.NAME],	
           [OE.MIDDLE.NAME],	
           [OE.LAST.NAME],	
           [OE.SUFFIX],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[ORG_ENTITY]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[PAC_LOAD_PERIODS_Current]
GO
CREATE VIEW [history].[PAC_LOAD_PERIODS_Current] AS
    SELECT 
           [PAC.LOAD.PERIODS.ID],	
           [PLP.HRP.ID],	
           [PLP.LP.ADV.ASGMTS.IDS],	
           [PLP.LP.CS.ASGMTS.IDS],	
           [PLP.LP.MEM.ASGMTS.IDS],	
           [PLP.PAC.LP.ASGMTS.IDS],	
           [PLP.PAC.LP.POSITION.IDS],	
           [PLP.PER.ASGMT.CONTRACT.ID],	
           [PLP.LOAD.PERIOD],	
           [PLP.INTENDED.TOTAL.LOAD],	
           [PLP.STATUSES],	
           [PLP.TOTAL.VALUE],	
           [PLP.USER1],	
           [PLP.USER2],	
           [PLP.USER3],	
           [PLP.USER4],	
           [PLP.USER5],	
           [PLP.USER6],	
           [PLP.USER7],	
           [PLP.USER8],	
           [PLP.USER9],	
           [PLP.USER10],	
           [PLP.STATUS.CHGOPR],	
           [PLP.STATUS.DATES],	
           [PAC.LOAD.PERIODS.ADDOPR],	
           [PAC.LOAD.PERIODS.ADDDATE],	
           [PAC.LOAD.PERIODS.CHGOPR],	
           [PAC.LOAD.PERIODS.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[PAC_LOAD_PERIODS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[PAC_LP_ASGMTS_Current]
GO
CREATE VIEW [history].[PAC_LP_ASGMTS_Current] AS
    SELECT 
           [PAC.LP.ASGMTS.ID],	
           [PLPA.PAC.LP.POSITIONS.ID],	
           [PLPA.ASGMT.ID],	
           [PLPA.HRP.ID],	
           [PLPA.PAYCLASS.ID],	
           [PLPA.ENTRY.ID],	
           [PLPA.START.DATE],	
           [PLPA.END.DATE],	
           [PLPA.ASGMT.TYPE],	
           [PLPA.BASE.AMT],	
           [PLPA.BASE.ET],	
           [PLPA.EARNDIFF.CODE],	
           [PLPA.PAID.LOAD],	
           [PLPA.STIPEND.IDS],	
           [PLPA.USER1],	
           [PLPA.USER2],	
           [PLPA.USER3],	
           [PLPA.USER4],	
           [PLPA.USER5],	
           [PLPA.USER6],	
           [PLPA.USER7],	
           [PLPA.USER8],	
           [PLPA.USER9],	
           [PLPA.USER10],	
           [PAC.LP.ASGMTS.ADDOPR],	
           [PAC.LP.ASGMTS.ADDDATE],	
           [PAC.LP.ASGMTS.CHGOPR],	
           [PAC.LP.ASGMTS.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[PAC_LP_ASGMTS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[PAC_LP_POSITIONS_Current]
GO
CREATE VIEW [history].[PAC_LP_POSITIONS_Current] AS
    SELECT 
           [PAC.LP.POSITIONS.ID],	
           [PLPP.HRP.ID],	
           [PLPP.PERPOS.ID],	
           [PLPP.PAC.LP.ASGMTS.IDS],	
           [PLPP.PAC.LOAD.PERIODS.ID],	
           [PLPP.POSITION.ID],	
           [PLPP.PPWG.PAYCLASS.ID],	
           [PLPP.LP.ADV.ASGMTS],	
           [PLPP.LP.CS.ASGMTS],	
           [PLPP.LP.MEM.ASGMTS],	
           [PLPP.START.DATE],	
           [PLPP.END.DATE],	
           [PLPP.INTENDED.LOAD],	
           [PLPP.PPWG.BASE.AMT],	
           [PLPP.PPWG.BASE.ET],	
           [PPLP.PPWG.GRADE],	
           [PPLP.PPWG.STEP],	
           [PLPP.USER1],	
           [PLPP.USER2],	
           [PLPP.USER3],	
           [PLPP.USER4],	
           [PLPP.USER5],	
           [PLPP.USER6],	
           [PLPP.USER7],	
           [PLPP.USER8],	
           [PLPP.USER9],	
           [PLPP.USER10],	
           [PAC.LP.POSITIONS.ADDOPR],	
           [PAC.LP.POSITIONS.ADDDATE],	
           [PAC.LP.POSITIONS.CHGOPR],	
           [PAC.LP.POSITIONS.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[PAC_LP_POSITIONS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[PAYTODAT_Current]
GO
CREATE VIEW [history].[PAYTODAT_Current] AS
    SELECT 
           [PTD.PERIOD.DATE],	
           [PTD.PAY.CYCLE],	
           [PTD.EMPLOYEE.ID],	
           [PTD.SEQ.NO],	
           [PTD.CHECK.ADVICE.DATE],	
           [PTD.PAY.MONTH],	
           [PTD.PAY.QUARTER],	
           [PTD.PAY.YEAR],	
           [PTD.TAX.YEAR],	
           [PTD.GROSS],	
           [PTD.NET],	
           [PTD.PERCENT.WORKED],	
           [PTD.HRP.STATUS],	
           [PTD.PAY.CYCLE.DESC],	
           [PTD.STATUS],	
           [PTD.POSITION.ID],	
           [PTD.EARN.TYPES],	
           [PTD.H.S.FLAGS],	
           [PTD.RATES],	
           [PTD.HOURS],	
           [PTD.AMOUNTS],	
           [PTD.BASE.EARNINGS],	
           [PTD.TAX.CODES],	
           [PTD.EMPLYE.TAX.AMTS],	
           [PTD.BD.CODES],	
           [PTD.BD.EMPLYE.CALC.AMTS],	
           [PTD.LV.CODES],	
           [PTD.LV.TYPES],	
           [PTD.LV.LIMITS],	
           [PTD.LV.ACCRUAL.RATES],	
           [PTD.LV.ACCRUED.HOURS],	
           [PTD.LV.ACCRUED.AMTS],	
           [PTD.LV.ACCRUED.COMMENTS],	
           [PTD.LV.PRIOR.BALANCES],	
           [PTD.LV.ACCRUED.FROM.ACCTS],	
           [PTD.LV.EARN.TYPES],	
           [PTD.LV.TKN.HOURS],	
           [PTD.LV.TKN.EARN.TYPES],	
           [PTD.LV.TKN.LEAVE.CODES],	
           [PTD.WEEKLY.WORK.UNITS],	
           [PTD.WEEKLY.START.DATES],	
           [PTD.WEEKLY.END.DATES],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[PAYTODAT]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[PERPOS_Current]
GO
CREATE VIEW [history].[PERPOS_Current] AS
    SELECT 
           [PERPOS.ID],	
           [PERPOS.HRP.ID],	
           [POSITION.ID],	
           [PERPOS.TITLE],	
           [PERPOS.POS.SHORT.TITLE],	
           [PERPOS.SUPERVISOR.HRP.ID],	
           [PERPOS.DEPT],	
           [ALL.POSITION.WAGES],	
           [XPERPOS.CURRENT.WAGE],	
           [PERPOS.END.REASON],	
           [PERPOS.FTE],	
           [PERPOS.ALT.SUPERVISOR.ID],	
           [PERPOS.APPOINTMENT.REASON],	
           [PERPOS.HRLY.OR.SLRY],	
           [PERPOS.WORK.WEEK.ID],	
           [PERPOS.LOCATION],	
           [PERPOS.APPOINTMENT.DATE],	
           [PERPOS.ANNIVERSARY.DATE],	
           [PERPOS.LAST.PAY.PERIOD.WORK],	
           [PERPOS.EFFECT.EMPLOY.DATE],	
           [PERPOS.START.DATE],	
           [PERPOS.END.DATE],	
           [PERPOS.ADD.OPERATOR],	
           [PERPOS.ADD.DATE],	
           [PERPOS.CHANGE.OPERATOR],	
           [PERPOS.CHANGE.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [PERPOS.POSITION.ID]
      FROM [history].[PERPOS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[PERPOSWG_Current]
GO
CREATE VIEW [history].[PERPOSWG_Current] AS
    SELECT 
           [PERPOSWG.ID],	
           [PPWG.PERPOS.ID],	
           [PPWG.HRP.ID],	
           [PPWG.DESC],	
           [PPWG.DEPT],	
           [PPWG.GRADE],	
           [PPWG.WORK.UNIT.RATE],	
           [PPWG.BASE.AMT],	
           [PPWG.PAY.RATE],	
           [PPWG.PI.PAY.RATE],	
           [PPWG.SH.PAY.RATE],	
           [PPWG.START.DATE],	
           [PPWG.END.DATE],	
           [PPWG.AUTHORIZED.DATE],	
           [PPWG.LAST.PAY.DATE],	
           [PERPOSWG.ADD.OPERATOR],	
           [PERPOSWG.ADD.DATE],	
           [PERPOSWG.CHANGE.OPERATOR],	
           [PERPOSWG.CHANGE.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [PPWG.IPEDS.CONTRACT.TYPE],	
           [PPWG.CONTRACT.LENGTH],	
           [PPWG.CONTRACT.UNITS],	
           [PPWG.YEAR.WORK.TIME.UNITS],	
           [PPWG.YEAR.WORK.TIME.AMT],	
           [PPWG.PAYCYCLE.ID],	
           [PPWG.CYCLE.WORK.TIME.UNITS],	
           [PPWG.CYCLE.WORK.TIME.AMT]
      FROM [history].[PERPOSWG]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[PERSON_Current]
GO
CREATE VIEW [history].[PERSON_Current] AS
    SELECT 
           [ID],	
           [FIRST.NAME],	
           [MIDDLE.NAME],	
           [LAST.NAME],	
           [SUFFIX],	
           [NAME.HISTORY.LAST.NAME],	
           [GENDER],	
           [BIRTH.DATE],	
           [DECEASED.DATE],	
           [MARITAL.STATUS],	
           [ETHNIC],	
           [PER.ETHNICS],	
           [PER.RACES],	
           [CITIZENSHIP],	
           [PERSON.ALT.IDS],	
           [ADDRESS.LINES],	
           [CITY],	
           [STATE],	
           [ZIP],	
           [ADDR.TYPE],	
           [RESIDENCE.COUNTY],	
           [RESIDENCE.STATE],	
           [RESIDENCE.COUNTRY],	
           [EMER.CONTACT.PHONE],	
           [PERSON.OVRL.EMP.STAT],	
           [VETERAN.TYPE],	
           [VETERAN.TYPE.DESCRIPTION],	
           [VISA.TYPE],	
           [PRIVACY.FLAG],	
           [PERSON.EMAIL.ADDRESSES],	
           [PERSON.EMAIL.TYPES],	
           [PERSONAL.PHONE.NUMBER],	
           [PERSONAL.PHONE.TYPE],	
           [PERSON.ADD.DATE],	
           [PERSON.ADD.OPERATOR],	
           [PERSON.CHANGE.DATE],	
           [PERSON.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [DIRECTORY.FLAG],	
           [X.ETHNICS.RACES],	
           [DRIVER.LICENSE.STATE],	
           [WHERE.USED],	
           [COUNTRY],	
           [DRIVER.LICENSE.NO],	
           [PER.PRI.ETHNIC],	
           [PER.PRI.RACE],	
           [PERSON.INSTITUTIONS.ATTEND]
      FROM [history].[PERSON]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[PERSON_ST_Current]
GO
CREATE VIEW [history].[PERSON_ST_Current] AS
    SELECT 
           [PERSON.ST.ID],	
           [PST.EDUC.GOALS],	
           [PST.ADVISOR.NAME],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [PST.STUDENT.NON.COURSES]
      FROM [history].[PERSON_ST]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[PERSTAT_Current]
GO
CREATE VIEW [history].[PERSTAT_Current] AS
    SELECT 
           [PERSTAT.ID],	
           [PERSTAT.HRP.ID],	
           [PERSTAT.BENEFIT.YEARS],	
           [PERSTAT.BENEFIT.YEARS.MOVR],	
           [PERSTAT.COMMENTS],	
           [PERSTAT.EEO.CATEGORY],	
           [PERSTAT.END.REASON],	
           [PERSTAT.FORMER.BENEFIT.YEARS],	
           [PERSTAT.FORMER.EMPLOY],	
           [PERSTAT.FORMER.SERVICE.YEARS],	
           [PERSTAT.GRAD.ASSIST],	
           [PERSTAT.IPEDS.FUNCTION],	
           [PERSTAT.PRIMARY.PERPOS.ID],	
           [PERSTAT.PRIMARY.POS.ID],	
           [PERSTAT.SERVICE.YEARS],	
           [PERSTAT.SERVICE.YEARS.MOVR],	
           [PERSTAT.STATUS],	
           [PERSTAT.TENURE.TYPE],	
           [PERSTAT.TENURE.TYPE.DATE],	
           [PERSTAT.START.DATE],	
           [PERSTAT.END.DATE],	
           [PERSTAT.ADD.DATE],	
           [PERSTAT.ADD.OPERATOR],	
           [PERSTAT.CHANGE.DATE],	
           [PERSTAT.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[PERSTAT]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[POSITION_Current]
GO
CREATE VIEW [history].[POSITION_Current] AS
    SELECT 
           [POSITION.ID],	
           [POS.SUPERVISOR.POS.ID],	
           [POS.DEPT],	
           [POS.DIVISION],	
           [POS.AUTHORIZED.DATE],	
           [POS.START.DATE],	
           [POS.END.DATE],	
           [POSITION.ADD.DATE],	
           [POSITION.CHANGE.DATE],	
           [POS.POSPAY.START.DATE],	
           [POS.POSPAY.END.DATE],	
           [POS.HRLY.OR.SLRY],	
           [POSITION.IN.USE],	
           [POS.LOCATION],	
           [POS.CLASS],	
           [POS.CLASS.DESC.CC],	
           [POS.DEPT.DESC.CC],	
           [POS.EEO.RANK],	
           [POS.EXEMPT.OR.NOT],	
           [POS.IPEDS.FUNCTION],	
           [POS.TITLE],	
           [POS.SHORT.TITLE],	
           [POS.UC.TITLE],	
           [POS.SOC.CODE],	
           [POS.TIME.ENTRY.FORM],	
           [POS.TIME.RECORDING],	
           [POS.TYPE],	
           [POS.TOTAL.FTE],	
           [POS.SCHOOL],	
           [POS.WORKLOAD.PCT],	
           [POS.DFLT.WORK.WEEK],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [ALL.POSPAY],	
           [POS.PRIMARY.POSPAY.GL],	
           [POS.POSPAY.GL.CC]
      FROM [history].[POSITION]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[POSPAY_Current]
GO
CREATE VIEW [history].[POSPAY_Current] AS
    SELECT 
           [POSPAY.ID],	
           [POSPAY.CYCLE.WORK.TIME.AMT],	
           [POSPAY.CYCLE.WORK.TIME.UNITS],	
           [POSPAY.FNDG.PCT],	
           [POSPAY.FNDG.GL.NO],	
           [POSPAY.FNDG.SOURCE],	
           [POSPAY.PAYCLASS],	
           [POSPAY.POSITION.ID],	
           [POSPAY.POSETYPE.ID],	
           [POSPAY.YEAR.WORK.TIME.AMT],	
           [POSPAY.YEAR.WORK.TIME.UNITS],	
           [POSPAY.AUTHORIZED.DATE],	
           [POSPAY.START.DATE],	
           [POSPAY.END.DATE],	
           [POSPAY.ADD.OPERATOR],	
           [POSPAY.ADD.DATE],	
           [POSPAY.CHANGE.OPERATOR],	
           [POSPAY.CHANGE.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[POSPAY]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[RULES_Current]
GO
CREATE VIEW [history].[RULES_Current] AS
    SELECT 
           [RULES.ID],	
           [RL.CHECK.CONNECTOR],	
           [RL.CHECK.DATA.ELEMENTS],	
           [RL.CHECK.DATA.USING],	
           [RL.CHECK.DATA.WHEN],	
           [RL.CHECK.DATA.WHEN.OPER],	
           [RL.CHECK.DATA.WHEN.VALUE],	
           [RL.CHECK.FAILURE.MSG],	
           [RL.CHECK.OPERATORS],	
           [RL.CHECK.VALUE.USING],	
           [RL.CHECK.VALUE.WHEN],	
           [RL.CHECK.VALUE.WHEN.OPER],	
           [RL.CHECK.VALUE.WHEN.VALUE],	
           [RL.CHECK.VALUES],	
           [RL.COMMENTS],	
           [RL.DESCRIPTION],	
           [RL.FAILURE.MSG],	
           [RL.OFFICE],	
           [RL.PRIMARY.VIEW],	
           [RL.SUBROUTINE.NAME],	
           [RULES.ADD.DATE],	
           [RULES.ADD.OPERATOR],	
           [RULES.CHANGE.DATE],	
           [RULES.CHANGE.OPERATOR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[RULES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[SA_ACYR_Current]
GO
CREATE VIEW [history].[SA_ACYR_Current] AS
    SELECT 
           [SA.STUDENT.ID],	
           [SA.ACTION],	
           [SA.AWARD],	
           [SA.AWARD.CATEGORY],	
           [SA.PELL.COA],	
           [SA.AWARDED],	
           [SA.AMOUNT],	
           [SA.XMIT.AMT],	
           [SA.HOURS.IN.PROGRAM],	
           [SA.HOURS.IN.AWD.PERIOD],	
           [SA.LOW.TUITION.CODE],	
           [SA.PELL.AWARD.CAT],	
           [SA.MBA],	
           [SA.MBA.USED],	
           [SA.TERMS],	
           [X.SA.AWARD.CATEGORY],	
           [X.SA.AWARD.DESTINATION],	
           [X.SA.AWARD.TYPE],	
           [SA.DATE],	
           [SA.PELL.DISB.REC.DATE],	
           [SA.ACYR.ADD.OPERATOR],	
           [SA.ACYR.ADD.DATE],	
           [SA.ACYR.CHANGE.OPERATOR],	
           [SA.ACYR.CHANGE.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [SA.YEAR]
      FROM [history].[SA_ACYR]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[SAP_RESULTS_Current]
GO
CREATE VIEW [history].[SAP_RESULTS_Current] AS
    SELECT 
           [SAP.RESULTS.ID],	
           [SAPR.STUDENT.ID],	
           [SAPR.SAP.STATUS],	
           [SAPR.TRM.REG.CRED],	
           [SAPR.TRM.CMPL.CRED],	
           [SAPR.TRM.GPA],	
           [SAPR.ACAD.PROGRAM],	
           [SAPR.ACADEMIC.TERMS],	
           [SAPR.CALC.DATE],	
           [SAP.RESULTS.ADDOPR],	
           [SAP.RESULTS.ADDDATE],	
           [SAP.RESULTS.CHGOPR],	
           [SAP.RESULTS.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[SAP_RESULTS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[SCHOOLS_Current]
GO
CREATE VIEW [history].[SCHOOLS_Current] AS
    SELECT 
           [SCHOOLS.ID],	
           [SCHOOLS.DESC],	
           [SCHOOLS.INSTITUTIONS.ID],	
           [SCHOOLS.DIVISIONS],	
           [SCHOOLS.DEPTS],	
           [SCHOOLS.ADD.OPERATOR],	
           [SCHOOLS.ADD.DATE],	
           [SCHOOLS.CHANGE.OPERATOR],	
           [SCHOOLS.CHANGE.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[SCHOOLS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[SOC_CODES_Current]
GO
CREATE VIEW [history].[SOC_CODES_Current] AS
    SELECT 
           [SOC.CODES.ID],	
           [SOC.DESC],	
           [SOC.FORMER.CODES],	
           [SOC.FORMER.DESCS],	
           [SOC.FORMER.YEARS],	
           [SOC.IPEDS.OCCUP.CATEG],	
           [SOC.LONG.DESC],	
           [SOC.REVISION.YEAR],	
           [SOC.CODES.ADDOPR],	
           [SOC.CODES.ADDDATE],	
           [SOC.CODES.ADDTIME],	
           [SOC.CODES.CHGOPR],	
           [SOC.CODES.CHGDATE],	
           [SOC.CODES.CHGTIME],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[SOC_CODES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[STATES_Current]
GO
CREATE VIEW [history].[STATES_Current] AS
    SELECT 
           [ID],	
           [ST.DESC],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[STATES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[STUDENT_ACAD_CRED_Current]
GO
CREATE VIEW [history].[STUDENT_ACAD_CRED_Current] AS
    SELECT 
           [STUDENT.ACAD.CRED.ID],	
           [STC.PERSON.ID],	
           [STC.TERM],	
           [STC.REPORTING.TERM],	
           [STC.COURSE],	
           [STC.SUBJECT],	
           [STC.CRS.NUMBER],	
           [STC.SECTION.NO],	
           [STC.TITLE],	
           [STC.COMMENTS],	
           [STC.COURSE.LEVEL],	
           [STC.ACAD.LEVEL],	
           [STC.CEUS],	
           [STC.CMPL.CEUS],	
           [X.808.DEV.CRED],	
           [STC.CRED],	
           [STC.CMPL.CRED],	
           [STC.CUM.CONTRIB.CMPL.CRED],	
           [XSTC.COUNT.FOR.FTE.V2],	
           [STC.CRED.TYPE],	
           [STC.DEPTS],	
           [STC.START.DATE],	
           [STC.END.DATE],	
           [STC.GRADE.SCHEME],	
           [STC.COURSE.SECTION],	
           [STC.STUDENT.COURSE.SEC],	
           [STC.STUDENT.EQUIV.EVAL],	
           [STC.VERIFIED.GRADE.CHGOPR],	
           [STC.VERIFIED.GRADE.DATE],	
           [STC.VERIFIED.GRADE],	
           [STC.FINAL.GRADE],	
           [STC.GRADE.PTS],	
           [STC.STATUS],	
           [STC.STATUS.DATE],	
           [STC.STATUS.TIME],	
           [STC.STATUS.REASON],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [STC.REPL.CODE],	
           [STC.COURSE.NAME]
      FROM [history].[STUDENT_ACAD_CRED]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[STUDENT_ACAD_LEVELS_Current]
GO
CREATE VIEW [history].[STUDENT_ACAD_LEVELS_Current] AS
    SELECT 
           [STA.STUDENT],	
           [STA.ACAD.LEVEL],	
           [STA.TERMS],	
           [STA.ADMIT.STATUS],	
           [STA.FED.COHORT.GROUP],	
           [STA.START.TERM],	
           [STA.CLASS],	
           [STA.STUDENT.STANDINGS.SAL],	
           [STA.CURRENT.STANDING],	
           [STA.START.DATE],	
           [STA.END.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[STUDENT_ACAD_LEVELS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[STUDENT_ADVISEMENT_Current]
GO
CREATE VIEW [history].[STUDENT_ADVISEMENT_Current] AS
    SELECT 
           [STUDENT.ADVISEMENT.ID],	
           [STAD.STUDENT],	
           [STAD.ACAD.LEVEL],	
           [STAD.ACAD.PROGRAM],	
           [STAD.TYPE],	
           [STAD.COMMENTS],	
           [STAD.FACULTY],	
           [STAD.START.DATE],	
           [STAD.END.DATE],	
           [STUDENT.ADVISEMENT.ADDOPR],	
           [STUDENT.ADVISEMENT.ADDDATE],	
           [STUDENT.ADVISEMENT.CHGOPR],	
           [STUDENT.ADVISEMENT.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[STUDENT_ADVISEMENT]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[STUDENT_COURSE_SEC_Current]
GO
CREATE VIEW [history].[STUDENT_COURSE_SEC_Current] AS
    SELECT 
           [STUDENT.COURSE.SEC.ID],	
           [STC.PERSON.ID],	
           [SCS.TERM],	
           [SCS.REG.METHOD],	
           [SCS.STUDENT.ACAD.CRED],	
           [XSCS.COUNT.FOR.FTE],	
           [SCS.AR.BALANCE],	
           [SCS.REG.TOTAL.BALANCE],	
           [SCS.REG.TOTAL.PAYMENT],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [SCS.PASS.AUDIT],	
           [SCS.STUDENT.TYPE],	
           [XSCS.PRI.ACAD.PROG],	
           [X.SCS.CR.HR]
      FROM [history].[STUDENT_COURSE_SEC]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[STUDENT_EQUIV_EVALS_Current]
GO
CREATE VIEW [history].[STUDENT_EQUIV_EVALS_Current] AS
    SELECT 
           [STUDENT.EQUIV.EVALS.ID],	
           [STE.COURSE.ACAD.CRED],	
           [STE.DESC],	
           [STE.EXTERNAL.TRANSCRIPTS],	
           [STE.GENERAL.ACAD.CRED],	
           [STE.INSTITUTION],	
           [STE.PERSON.ID],	
           [STE.STUDENT.ACAD.CRED],	
           [STE.STUDENT.NON.COURSE],	
           [STUDENT.EQUIV.EVALS.ADDDATE],	
           [STUDENT.EQUIV.EVALS.ADDOPR],	
           [STUDENT.EQUIV.EVALS.CHGDATE],	
           [STUDENT.EQUIV.EVALS.CHGOPR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[STUDENT_EQUIV_EVALS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[STUDENT_NON_COURSES_Current]
GO
CREATE VIEW [history].[STUDENT_NON_COURSES_Current] AS
    SELECT 
           [STUDENT.NON.COURSES.ID],	
           [STNC.PERSON.ID],	
           [STNC.NON.COURSE],	
           [STNC.TITLE],	
           [STNC.SCORE],	
           [STNC.SUBCOMPONENT.SCORES],	
           [STNC.TEST.TYPE],	
           [STNC.SOURCE],	
           [STNC.CATEGORY],	
           [STNC.STUDENT.EQUIV.EVAL],	
           [STNC.INSTITUTION],	
           [STNC.NON.CRS.GRADE.USE],	
           [STNC.STATUS],	
           [STNC.START.DATE],	
           [STNC.END.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [STNC.CATEGORY.TRANSLATION],	
           [STNC.STATUS.DATE]
      FROM [history].[STUDENT_NON_COURSES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[STUDENT_PROGRAMS_Current]
GO
CREATE VIEW [history].[STUDENT_PROGRAMS_Current] AS
    SELECT 
           [STPR.ACAD.PROGRAM],	
           [STPR.STUDENT],	
           [STPR.ADMIT.STATUS],	
           [STPR.CATALOG],	
           [STPR.DEPT],	
           [STPR.START.DATE],	
           [STPR.END.DATE],	
           [STPR.EVAL.MAJOR.GPA],	
           [STPR.STUDENT.ED.PLAN],	
           [STPR.USER1],	
           [STPR.STATUS],	
           [STPR.STATUS.DATE],	
           [STPR.STATUS.CHGOPR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [STPR.EVAL.MAJORS],	
           [STPR.EVAL.MAJOR.CRED.TOT],	
           [STPR.EVAL.MAJOR.STATUS],	
           [STPR.EVAL.INSTITUTION.GPA],	
           [STPR.EVAL.INSTITUTION.CRED]
      FROM [history].[STUDENT_PROGRAMS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[STUDENT_TERMS_Current]
GO
CREATE VIEW [history].[STUDENT_TERMS_Current] AS
    SELECT 
           [STTR.STUDENT],	
           [STTR.TERM],	
           [STTR.ACAD.LEVEL],	
           [STTR.ACTIVE.PROGRAMS],	
           [X.STTR.PROGRAM.TITLE],	
           [STTR.START.DATE],	
           [STTR.FED.COHORT.GROUP],	
           [STTR.ACTIVE.CRD.LEVELS],	
           [STU.CMPL.CRED],	
           [STTR.CUM.GPA],	
           [STTR.ALL.CRED],	
           [STTR.CMPL.CRED],	
           [STTR.ACTIVE.CRED],	
           [STTR.STUDENT.LOAD],	
           [STTR.GPA],	
           [STTR.STUDENT.TYPE],	
           [STTR.ALIEN.FLAG],	
           [STTR.ADMIT.STATUS],	
           [STTR.STATUS],	
           [STTR.STATUS.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[STUDENT_TERMS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[STUDENTS_Current]
GO
CREATE VIEW [history].[STUDENTS_Current] AS
    SELECT 
           [STUDENTS.ID],	
           [STU.RESIDENCY.STATUS],	
           [STU.RESIDENCY.STATUS.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [STU.TOT.CRS],	
           [STU.TYPE.DATES],	
           [STU.TYPES],	
           [STU.TYPE.END.DATES],	
           [STU.CLASS],	
           [STU.DIR.FLAG],	
           [STU.SSN],	
           [STU.TERMS],	
           [STU.START.TERM]
      FROM [history].[STUDENTS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[SUBJECTS_Current]
GO
CREATE VIEW [history].[SUBJECTS_Current] AS
    SELECT 
           [SUBJECTS.ID],	
           [SUBJ.DESC],	
           [SUBJECTS.ADDDATE],	
           [SUBJECTS.ADDOPR],	
           [SUBJECTS.CHGDATE],	
           [SUBJECTS.CHGOPR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[SUBJECTS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[TA_ACYR_Current]
GO
CREATE VIEW [history].[TA_ACYR_Current] AS
    SELECT 
           [TA.STUDENT.ID],	
           [TA.ACYR],	
           [TA.FIRST],	
           [TA.MIDDLE],	
           [TA.LAST],	
           [TA.AWDP.START.DATE],	
           [TA.TERM],	
           [TA.REG.CREDITS],	
           [TA.QUERY.REG.CREDITS],	
           [TA.NEED],	
           [TA.INST.NEED],	
           [TA.AW.ID],	
           [TA.AWARD.CATEGORY],	
           [TA.TERM.ACTION],	
           [TA.TERM.AMOUNT],	
           [TA.AMT.FLAG],	
           [TA.TERM.XMIT.AMT],	
           [TA.TERM.XMIT.DT],	
           [TA.XMIT.FLAG],	
           [TA.TERM.UNXMIT.AMT],	
           [TA.D7.EXCESS.XMIT.AMT],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[TA_ACYR]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[TERMS_Current]
GO
CREATE VIEW [history].[TERMS_Current] AS
    SELECT 
           [TERMS.ID],	
           [TERM.DESC],	
           [TERM.START.DATE],	
           [TERM.CENSUS.DATES],	
           [TERM.END.DATE],	
           [TERM.REPORTING.YEAR],	
           [TERM.COMMENCEMENT.DATE],	
           [TERM.DROP.START.DATE],	
           [TERM.DROP.END.DATE],	
           [TERM.REG.START.DATE],	
           [TERM.REG.END.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[TERMS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[XCC_ACAD_PROG_REQMTS_Current]
GO
CREATE VIEW [history].[XCC_ACAD_PROG_REQMTS_Current] AS
    SELECT 
           [XCCAPR.ACAD.PROGRAM],	
           [XCCAPR.CATALOG],	
           [XCC.ACAD.PROG.REQMTS.ID],	
           [XCCAPR.COMMENTS],	
           [XCCAPR.COMPARE.FLAG],	
           [XCCAPR.CREDENTIAL],	
           [XCCAPR.CURR.STANDARD],	
           [XCCAPR.LOCAL.DESC],	
           [XCCAPR.MAJOR],	
           [XCCAPR.PARENT.POS],	
           [XCCAPR.PROG.TYPE],	
           [XCCAPR.PROGRAM.GPA],	
           [XCCAPR.PROGRAM.GROUP],	
           [XCCAPR.PROGRAM.TITLE],	
           [XCCAPR.ROLLOVER.FLAG],	
           [XCCAPR.TRANS.COURSES],	
           [XCCAPR.APPROVAL.AGENCY.IDS],	
           [XCCAPR.APPROVAL.IDS],	
           [XCCAPR.APPROVAL.DATES],	
           [XCCAPR.PRES.APPROVAL.DATE],	
           [XCCAPR.START.DATE],	
           [XCCAPR.END.DATE],	
           [XCCAPR.SUBMIT.DATE],	
           [XCCAPR.LAST.DOWNLOAD],	
           [XCCAPR.STATUS],	
           [XCCAPR.STATUS.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[XCC_ACAD_PROG_REQMTS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[XCC_ACAD_PROGRAMS_Current]
GO
CREATE VIEW [history].[XCC_ACAD_PROGRAMS_Current] AS
    SELECT 
           [XCC.ACAD.PROGRAMS.ID],	
           [XCCAP.ASSOC.CATALOG],	
           [XCCAP.ASSOC.PROGRAM],	
           [XCCAP.CAPTIVE.FLAG],	
           [XCCAP.HOST.INST],	
           [XCCAP.LAST.CURR.STND],	
           [XCCAP.LAST.DOWNLOAD],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[XCC_ACAD_PROGRAMS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[XCE_ICR_Current]
GO
CREATE VIEW [history].[XCE_ICR_Current] AS
    SELECT 
           [XCE.ICR.ID],	
           [Term_ID],	
           [XCE.COURSE.PREFIX],	
           [XCE.COURSE.NUMBER],	
           [XCE.SECTION.NUMBER],	
           [XCE.CEBS.HOURS],	
           [XCE.CELL.HOURS],	
           [XCE.CONTRACT.AGENCY],	
           [XCE.CONTRACT.NUMBER],	
           [XCE.COUNTY],	
           [XCE.COURSE.SECTIONS.ID],	
           [XCE.FINT.HOURS],	
           [XCE.GSRS.HOURS],	
           [XCE.HOUR.TYPE],	
           [XCE.HRDT.HOURS],	
           [XCE.IMMURED.GROUP],	
           [XCE.INSTRUCTION.METHOD],	
           [XCE.LOCATION.CODE],	
           [XCE.NEIT.HOURS],	
           [XCE.NOSS.HOURS],	
           [XCE.OERB.HOURS],	
           [XCE.OESS.HOURS],	
           [XCE.ONOFF.CAMPUS],	
           [XCE.SBCT.HOURS],	
           [XCE.SCHED.HOURS],	
           [XCE.SPECIAL.CLASS],	
           [XCE.TERM],	
           [XCE.TOTAL.HOURS],	
           [XCE.TOTAL.STUDENTS],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[XCE_ICR]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[XCOURSE_SECTIONS_Current]
GO
CREATE VIEW [history].[XCOURSE_SECTIONS_Current] AS
    SELECT 
           [XCOURSE.SECTIONS.ID],	
           [XSEC.CATEGORY],	
           [XSEC.CE.AGENCY],	
           [XSEC.CE.CRED],	
           [XSEC.CE.TIER.DATE.ELIG],	
           [XSEC.CE.TIER.ELIG],	
           [XSEC.CE.TIER.FUNDED],	
           [XSEC.CE.TIER.MAIN.CRED],	
           [XSEC.CE.TIER.MAIN.CRED.AGCY],	
           [XSEC.CE.TIER.SEC.CRED],	
           [XSEC.CE.TIER.SEC.CRED.AGCY],	
           [XSEC.DELIVERY.METHOD],	
           [XSEC.DELIVERY.MODE],	
           [XSEC.DELIVERY.MODIFIER],	
           [XSEC.DELIVERY.NCIH.FLAG],	
           [XSEC.FIN.GRD.SUBMIT.DATE],	
           [XSEC.FIN.GRD.SUBMIT.OPR],	
           [XSEC.WEB.ATT.INST.METH],	
           [XSEC.WEBATT.FINAL.SIGN],	
           [XSEC.WEBATT.FINAL.SIGN.DATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[XCOURSE_SECTIONS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[XCU_ICR_Current]
GO
CREATE VIEW [history].[XCU_ICR_Current] AS
    SELECT 
           [XCU.ICR.ID],	
           [XCU.TERM],	
           [XCU.COURSE.SECTIONS.ID],	
           [XCU.COURSE.SECTION.NAME],	
           [XCU.COURSE.PREFIX],	
           [XCU.COURSE.NUMBER],	
           [XCU.SECTION.NUMBER],	
           [XCU.CENSUS.PERCENTAGE],	
           [XCU.CONTRACT.AGENCY],	
           [XCU.COUNTY],	
           [XCU.COURSE.TYPE],	
           [XCU.HOUR.TYPE],	
           [XCU.IMMURED.GROUP],	
           [XCU.INSTRUCTION.METHOD],	
           [XCU.LOCATION.CODE],	
           [XCU.ONOFF.CAMPUS],	
           [XCU.SELF.SUPPORTING],	
           [XCU.SPECIAL.FUNDING],	
           [XCU.TOTAL.STUDENTS],	
           [XCU.SCHED.HOURS],	
           [XCU.TOTAL.HOURS],	
           [XCU.ACAD.PROGRAM],	
           [XCU.CCP.CODE],	
           [XCU.HS.STU.CODE],	
           [XCU.TIER.FUNDING.CODE],	
           [XCU.TIER.FUNDING.TERM],	
           [FTE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[XCU_ICR]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[XFA_NCHED_AW_CODES_Current]
GO
CREATE VIEW [history].[XFA_NCHED_AW_CODES_Current] AS
    SELECT 
           [XFA.NCHED.AW.CODES.ID],	
           [XFA.NCHED.AW.CODE.DESC],	
           [XFA.NCHED.AW.SECTION],	
           [XFA.NCHED.AW.SORT],	
           [XFA.NCHED.AW.TYPE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[XFA_NCHED_AW_CODES]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[XLE_STUDENTS_Current]
GO
CREATE VIEW [history].[XLE_STUDENTS_Current] AS
    SELECT 
           [XLE.STUDENTS.ID],	
           [XLE.AHS.NEEDED],	
           [XLE.AHS.COMPLETE],	
           [XLE.AHS.TRANS.IN],	
           [XLE.AHS.TRANS.DATE],	
           [XLE.STU.INTAKE.DATE],	
           [XLE.SEPARATION.DATE],	
           [XLE.TEST.CODE],	
           [XLE.TEST.DATE],	
           [XLE.TEST.SCORE],	
           [XLE.STUDENT.DATA],	
           [XLE.AHS.1ST.ATTDATE],	
           [XLE.AHS.1ST.COMDATE],	
           [XLE.STUDENTS.ADDDATE],	
           [XLE.STUDENTS.ADDTIME],	
           [XLE.STUDENTS.ADDOPR],	
           [XLE.STUDENTS.CHGDATE],	
           [XLE.STUDENTS.CHGTIME],	
           [XLE.STUDENTS.CHGOPR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[XLE_STUDENTS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[XNC_HRPER_Current]
GO
CREATE VIEW [history].[XNC_HRPER_Current] AS
    SELECT 
           [XNC.HRPER.ID],	
           [XHRP.ACAD.LEVEL],	
           [ACAD.LEVEL.DESC],	
           [XHRP.AOI],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[XNC_HRPER]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[XNC_PERSON_Current]
GO
CREATE VIEW [history].[XNC_PERSON_Current] AS
    SELECT 
           [XNC.PERSON.ID],	
           [XNC.EDU.ENTRY.LEVEL],	
           [XNC.FATHER.DEGREE.FLAG],	
           [XNC.MOTHER.DEGREE.FLAG],	
           [XNC.HEAD.HOUSEHOLD.FLAG],	
           [XNC.SINGLE.PARENT.FLAG],	
           [XNC.ECON.DISADVANTAGED.FLAG],	
           [XNC.LIMITED.ENGLISH.FLAG],	
           [XNC.INMATE.FLAG],	
           [XNC.HIGH.SCHOOL.TRACK],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag],	
           [XNC.HS.GRAD.DATE],	
           [XNC.LAST.EMPLOY.DATE],	
           [XNC.HS.LAST.ATTENDED.DATE],	
           [XNC.HS.STU.ID],	
           [XNC.PATHWAY.ENTRY],	
           [XNC.PATHWAY.TYPE],	
           [XNC.PATHWAY.END.DATE]
      FROM [history].[XNC_PERSON]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[XPAC_LP_ASGMTS_Current]
GO
CREATE VIEW [history].[XPAC_LP_ASGMTS_Current] AS
    SELECT 
           [XPAC.LP.ASGMTS.ID],	
           [XPLPA.ACAD.LEVEL],	
           [XPLPA.HOURS],	
           [XPLPA.INSTALLMENTS],	
           [XPLPA.MONTHS],	
           [XPLPA.MTH.HOURS],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[XPAC_LP_ASGMTS]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[XST_RES_CERT_Current]
GO
CREATE VIEW [history].[XST_RES_CERT_Current] AS
    SELECT 
           [XST.RES.CERT.ID],	
           [XRDS.CAT.CODE],	
           [XRDS.CONT.ENROLL.EXP],	
           [XRDS.COUNTRY.CODE],	
           [XRDS.COUNTY.CODE],	
           [XRDS.DOC.COMP],	
           [XRDS.INBOUND.TRANS.IDS],	
           [XRDS.LAST.REQ.DT],	
           [XRDS.LAST.TERM.ENR],	
           [XRDS.LAST.TERM.ENR.CALC.DT],	
           [XRDS.NCCCS.EXCEPTION.CODE],	
           [XRDS.OUTBOUND.TRANS.IDS],	
           [XRDS.RCN.EXP.DATE],	
           [XRDS.RCN.LAST.UPDATE],	
           [XRDS.REC.TYPE],	
           [XRDS.REQ.PENDING],	
           [XRDS.RES.CERT.NO],	
           [XRDS.RES.CODE],	
           [XRDS.RPTONLY.TRANS.IDS],	
           [XRDS.STAT.CHG.DATE],	
           [XRDS.STATE.CODE],	
           [XRDS.TRACK.FLAG],	
           [XRDS.TRACK.FLAG.DATE],	
           [XRDS.TUITION.CODE],	
           [XRDS.UNC.EXCEPTION.CODE],	
           [XRDS.VALIDATED.FLAG],	
           [XRDS.VERIFIED.RCN],	
           [XST.RES.CERT.ADDDATE],	
           [XST.RES.CERT.ADDOPR],	
           [XST.RES.CERT.CHGDATE],	
           [XST.RES.CERT.CHGOPR],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[XST_RES_CERT]
     WHERE CurrentFlag = 'Y'
GO

DROP VIEW [history].[XSUBJECTS_Current]
GO
CREATE VIEW [history].[XSUBJECTS_Current] AS
    SELECT 
           [XSUBJECTS.ID],	
           [XSUBJ.CU.TIER],	
           [XSUBJ.CU.TIER.TERM],	
           [XSUBJ.CU.TIER.DATE],	
           [XSUBJECTS.ADDOPR],	
           [XSUBJECTS.ADDDATE],	
           [XSUBJECT.CHGOPR],	
           [XSUBJECTS.CHGDATE],	
           [Audit_Key],	
           [EffectiveDatetime],	
           [ExpirationDatetime],	
           [CurrentFlag]
      FROM [history].[XSUBJECTS]
     WHERE CurrentFlag = 'Y'
GO
