CREATE TABLE [input].[ACAD_CREDENTIALS] ( 
    [ACAD.ACAD.PROGRAM] nvarchar(10) NULL, /* Versions: 1001- */
    [ACAD.CREDENTIALS.ID] int NULL, /* Versions: 1001- */
    [ACAD.PERSON.ID] nvarchar(10) NULL, /* Versions: 1001- */
    [ACAD.TERM] nvarchar(7) NULL, /* Versions: 1001- */
    [ACAD.TRANSCRIPT.ADDRESS] nvarchar(255) NULL, /* Versions: 1001- */
    [ACAD.TRANSCRIPT.CITY] nvarchar(100) NULL, /* Versions: 1001- */
    [ACAD.TRANSCRIPT.COUNTRY] nvarchar(100) NULL, /* Versions: 1001- */
    [ACAD.TRANSCRIPT.STATE] nvarchar(5) NULL, /* Versions: 1001- */
    [ACAD.TRANSCRIPT.ZIP] nvarchar(10) NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[ACAD_PROGRAMS] ( 
    [ACAD.PROGRAMS.ID] nvarchar(10) NULL, /* Versions: 1001- */
    [ACPG.ACAD.LEVEL] nvarchar(3) NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[ADDRESS] ( 
    [ADDRESS.ID] int NULL, /* Versions: 1001- */
    [ADDRESS.LINES] nvarchar(255) NULL, /* Versions: 1001- */
    [CITY] nvarchar(100) NULL, /* Versions: 1001- */
    [COUNTRY] nvarchar(5) NULL, /* Versions: 1001- */
    [COUNTY] nvarchar(5) NULL, /* Versions: 1001- */
    [STATE] nvarchar(5) NULL, /* Versions: 1001- */
    [ZIP] nvarchar(10) NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[COURSE_SEC_FACULTY] ( 
    [COURSE.SEC.FACULTY.ID] int NULL, /* Versions: 1001- */
    [CSF.FACULTY] nvarchar(10) NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[CSM.DAYS_MV] ( 
    [CCSM.DAYS_MV_ID] int NOT NULL,
    [CSM.DAYS] nvarchar(2) NULL, /* Versions: 1001- */
    [CSM.DAYS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

	CONSTRAINT [PK_CSM.DAYS_MV] PRIMARY KEY ([CCSM.DAYS_MV_ID])
	)

CREATE TABLE [input].[COURSE_SEC_MEETING] ( 
    [COURSE.SEC.MEETING.ADDDATE] date NULL, /* Versions: 1001- */
    [COURSE.SEC.MEETING.ADDOPR] nvarchar(20) NULL, /* Versions: 1001- */
    [COURSE.SEC.MEETING.CHGDATE] date NULL, /* Versions: 1001- */
    [COURSE.SEC.MEETING.CHGOPR] nvarchar(20) NULL, /* Versions: 1001- */
    [COURSE.SEC.MEETING.ID] int NULL, /* Versions: 1001- */
    [CSM.BLDG] nvarchar(5) NULL, /* Versions: 1001- */
    [CSM.COURSE.SECTION] int NULL, /* Versions: 1001- */
    [CSM.DAYS_MV_ID] int NULL,
    [CSM.END.DATE] date NULL, /* Versions: 1001- */
    [CSM.END.TIME] time(7) NULL, /* Versions: 1001- */
    [CSM.INSTR.METHOD] nvarchar(10) NULL, /* Versions: 1001- */
    [CSM.ROOM] nvarchar(10) NULL, /* Versions: 1001- */
    [CSM.START.DATE] date NULL, /* Versions: 1001- */
    [CSM.START.TIME] time(7) NULL, /* Versions: 1001- */
    [Current Date] date NULL, 

    CONSTRAINT [FK_COURSE_SEC_MEETING_CSM.DAYS_MV] 
		FOREIGN KEY ([CSM.DAYS_MV_ID]) 
		REFERENCES [input].[CSM.DAYS_MV]([CCSM.DAYS_MV_ID])
	)

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[SEC.ACTIVE.STUDENTS_MV] ( 
    [SEC.ACTIVE.STUDENTS_MV_ID] int NOT NULL,
    [SEC.ACTIVE.STUDENTS] nvarchar(10) NULL, /* Versions: 1001- */
    [SEC.ACTIVE.STUDENTS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_SEC.ACTIVE.STUDENTS_MV] PRIMARY KEY ([SEC.ACTIVE.STUDENTS_MV_ID])
    )


CREATE TABLE [input].[SEC.CONTACT.HOURS_MV] ( 
    [SEC.CONTACT.HOURS_MV_ID] int NOT NULL,
    [SEC.CONTACT.HOURS] decimal(9,2) NULL, /* Versions: 1001- */
    [SEC.CONTACT.HOURS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_SEC.CONTACT.HOURS_MV] PRIMARY KEY ([SEC.CONTACT.HOURS_MV_ID])
    )


CREATE TABLE [input].[SEC.CONTACT.MEASURES_MV] ( 
    [SEC.CONTACT.MEASURES_MV_ID] int NOT NULL,
    [SEC.CONTACT.MEASURES] nvarchar(2) NULL, /* Versions: 1001- */
    [SEC.CONTACT.MEASURES.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_SEC.CONTACT.MEASURES_MV] PRIMARY KEY ([SEC.CONTACT.MEASURES_MV_ID])
    )


CREATE TABLE [input].[SEC.COURSE.LEVELS_MV] ( 
    [SEC.COURSE.LEVELS_MV_ID] int NOT NULL,
    [SEC.COURSE.LEVELS] nvarchar(5) NULL, /* Versions: 1001- */
    [SEC.COURSE.LEVELS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_SEC.COURSE.LEVELS_MV] PRIMARY KEY ([SEC.COURSE.LEVELS_MV_ID])
    )


CREATE TABLE [input].[SEC.COURSE.TYPES_MV] ( 
    [SEC.COURSE.TYPES_MV_ID] int NOT NULL,
    [SEC.COURSE.TYPES] nvarchar(10) NULL, /* Versions: 1001- */
    [SEC.COURSE.TYPES.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_SEC.COURSE.TYPES_MV] PRIMARY KEY ([SEC.COURSE.TYPES_MV_ID])
    )


CREATE TABLE [input].[SEC.FACULTY_MV] ( 
    [SEC.FACULTY_MV_ID] int NOT NULL,
    [SEC.FACULTY] int NULL, /* Versions: 1001- */
    [SEC.FACULTY.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_SEC.FACULTY_MV] PRIMARY KEY ([SEC.FACULTY_MV_ID])
    )


CREATE TABLE [input].[SEC.STATUS_MV] ( 
    [SEC.STATUS_MV_ID] int NOT NULL,
    [SEC.STATUS] nvarchar(2) NULL, /* Versions: 1001- */
    [SEC.STATUS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_SEC.STATUS_MV] PRIMARY KEY ([SEC.STATUS_MV_ID])
    )

CREATE TABLE [input].[COURSE_SECTIONS] ( 
    [COURSE.SECTIONS.ADDDATE] date NULL, /* Versions: 1001- */
    [COURSE.SECTIONS.ADDOPR] nvarchar(20) NULL, /* Versions: 1001- */
    [COURSE.SECTIONS.CHGDATE] date NULL, /* Versions: 1001- */
    [COURSE.SECTIONS.CHGOPR] nvarchar(20) NULL, /* Versions: 1001- */
    [COURSE.SECTIONS.ID] int NULL, /* Versions: 1001- */
    [SEC.ACAD.LEVEL] nvarchar(5) NULL, /* Versions: 1001- */
    [SEC.ACTIVE.STUDENTS_MV_ID] int NULL,
    [SEC.CAPACITY] int NULL, /* Versions: 1001- */
    [SEC.CEUS] decimal(9,2) NULL, /* Versions: 1001- */
    [SEC.CONTACT.HOURS_MV_ID] int NULL,
    [SEC.CONTACT.MEASURES_MV_ID] int NULL,
    [SEC.COURSE.LEVELS_MV_ID] int NULL,
    [SEC.COURSE.NO] int NULL, /* Versions: 1001- */
    [SEC.COURSE.TYPES_MV_ID] int NULL,
    [SEC.CRED.TYPE] nvarchar(3) NULL, /* Versions: 1001- */
    [SEC.DEPTS] nvarchar(10) NULL, /* Versions: 1001- */
    [SEC.FACULTY_MV_ID] int NULL,
    [SEC.FUNDING.ACCTG.METHOD] nvarchar(2) NULL, /* Versions: 1001- */
    [SEC.FUNDING.SOURCES] nvarchar(5) NULL, /* Versions: 1001- */
    [SEC.LOCAL.GOVT.CODES] nvarchar(10) NULL, /* Versions: 1001- */
    [SEC.LOCATION] nvarchar(5) NULL, /* Versions: 1001- */
    [SEC.MIN.CRED] decimal(9,2) NULL, /* Versions: 1001- */
    [SEC.NO] nvarchar(5) NULL, /* Versions: 1001- */
    [SEC.SHORT.TITLE] nvarchar(100) NULL, /* Versions: 1001- */
    [SEC.STATUS_MV_ID] int NULL,
    [SEC.SUBJECT] nvarchar(50) NULL, /* Versions: 1001- */
    [SEC.SYNONYM] int NULL, /* Versions: 1001- */
    [SEC.TERM] nvarchar(7) NULL, /* Versions: 1001- */
    [SEC.USER1] nvarchar(3) NULL, /* Versions: 1001- */
    [Current Date] date NULL, 

    CONSTRAINT [FK_COURSE_SECTIONS_SEC.ACTIVE.STUDENTS_MV] 
        FOREIGN KEY ([SEC.ACTIVE.STUDENTS_MV_ID]) 
        REFERENCES [input].[SEC.ACTIVE.STUDENTS_MV]([SEC.ACTIVE.STUDENTS_MV_ID])
    , 

    CONSTRAINT [FK_COURSE_SECTIONS_SEC.CONTACT.HOURS_MV] 
        FOREIGN KEY ([SEC.CONTACT.HOURS_MV_ID]) 
        REFERENCES [input].[SEC.CONTACT.HOURS_MV]([SEC.CONTACT.HOURS_MV_ID])
    , 

    CONSTRAINT [FK_COURSE_SECTIONS_SEC.CONTACT.MEASURES_MV] 
        FOREIGN KEY ([SEC.CONTACT.MEASURES_MV_ID]) 
        REFERENCES [input].[SEC.CONTACT.MEASURES_MV]([SEC.CONTACT.MEASURES_MV_ID])
    , 

    CONSTRAINT [FK_COURSE_SECTIONS_SEC.COURSE.LEVELS_MV] 
        FOREIGN KEY ([SEC.COURSE.LEVELS_MV_ID]) 
        REFERENCES [input].[SEC.COURSE.LEVELS_MV]([SEC.COURSE.LEVELS_MV_ID])
    , 

    CONSTRAINT [FK_COURSE_SECTIONS_SEC.COURSE.TYPES_MV] 
        FOREIGN KEY ([SEC.COURSE.TYPES_MV_ID]) 
        REFERENCES [input].[SEC.COURSE.TYPES_MV]([SEC.COURSE.TYPES_MV_ID])
    , 

    CONSTRAINT [FK_COURSE_SECTIONS_SEC.FACULTY_MV] 
        FOREIGN KEY ([SEC.FACULTY_MV_ID]) 
        REFERENCES [input].[SEC.FACULTY_MV]([SEC.FACULTY_MV_ID])
    , 

    CONSTRAINT [FK_COURSE_SECTIONS_SEC.STATUS_MV] 
        FOREIGN KEY ([SEC.STATUS_MV_ID]) 
        REFERENCES [input].[SEC.STATUS_MV]([SEC.STATUS_MV_ID])
    )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[CRS.COURSE.TYPES_MV] ( 
    [CRS.COURSE.TYPES_MV_ID] int NOT NULL,
    [CRS.COURSE.TYPES] nvarchar(5) NULL, /* Versions: 1001- */
    [CRS.COURSE.TYPES.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_CRS.COURSE.TYPES_MV] PRIMARY KEY ([CRS.COURSE.TYPES_MV_ID])
    )

CREATE TABLE [input].[COURSES] ( 
    [COURSES.ID] nvarchar(10) NULL, /* Versions: 1001- */
    [CRS.COURSE.TYPES_MV_ID] int NULL,
    [CRS.NO] nvarchar(10) NULL, /* Versions: 1001- */
    [Current Date] date NULL, 

    CONSTRAINT [FK_COURSES_CRS.COURSE.TYPES_MV] 
        FOREIGN KEY ([CRS.COURSE.TYPES_MV_ID]) 
        REFERENCES [input].[CRS.COURSE.TYPES_MV]([CRS.COURSE.TYPES_MV_ID])
    )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[ETHNICS] ( 
    [ETHNICS.ID] int NULL, /* Versions: 1001- */
    [ETH.DESC] nvarchar(50) NULL, /* Versions: 1001- */
    [ETHNICS.ADD.DATE] date NULL, /* Versions: 1001- */
    [ETHNICS.ADD.OPERATOR] nvarchar(20) NULL, /* Versions: 1001- */
    [ETHNICS.CHANGE.DATE] date NULL, /* Versions: 1001- */
    [ETHNICS.CHANGE.OPERATOR] nvarchar(20) NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[GRADES] ( 
    [GRADES.ID] int NULL, /* Versions: 1001- */
    [GRD.GRADE] nvarchar(3) NULL, /* Versions: 1001- */
    [GRD.LEGEND] nvarchar(20) NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[INSTITUTIONS] ( 
    [INST.TYPE] nvarchar(3) NULL, /* Versions: 1001- */
    [INSTITUTIONS.ID] nvarchar(10) NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[INSTITUTIONS_ATTEND] ( 
    [INSTA.END.DATES] date NULL, /* Versions: 1001- */
    [INSTA.GRAD.TYPE] nvarchar(2) NULL, /* Versions: 1001- */
    [INSTA.INSTITUTIONS.ID] nvarchar(10) NULL, /* Versions: 1001- */
    [INSTA.PERSON.ID] nvarchar(10) NULL, /* Versions: 1001- */
    [INSTA.START.DATES] date NULL, /* Versions: 1001- */
    [INSTA.TRANSCRIPT.DATE] date NULL, /* Versions: 1001- */
    [INSTA.TRANSCRIPT.STATUS] nvarchar(2) NULL, /* Versions: 1001- */
    [INSTA.TRANSCRIPT.TYPE] nvarchar(3) NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[JSPARAMS] ( 
    [JS.VAR2] nvarchar(3) NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[NON_COURSES] ( 
    [NCRS.TYPE] nvarchar(10) NULL, /* Versions: 1001- */
    [NON.COURSES.ID] nvarchar(20) NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[ADDR.TYPE_MV] ( 
    [ADDR.TYPE_MV_ID] int NOT NULL,
    [ADDR.TYPE] nvarchar(5) NULL, /* Versions: 1001- */
    [ADDR.TYPE.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_ADDR.TYPE_MV] PRIMARY KEY ([ADDR.TYPE_MV_ID])
    )

CREATE TABLE [input].[NAME.HISTORY.LAST.NAME_MV] ( 
    [NAME.HISTORY.LAST.NAME_MV_ID] int NOT NULL,
    [NAME.HISTORY.LAST.NAME] nvarchar(25) NULL, /* Versions: 1001- */
    [NAME.HISTORY.LAST.NAME.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_NAME.HISTORY.LAST.NAME_MV] PRIMARY KEY ([NAME.HISTORY.LAST.NAME_MV_ID])
    )

CREATE TABLE [input].[PERSON.ALT.IDS_MV] ( 
    [PERSON.ALT.IDS_MV_ID] int NOT NULL,
    [PERSON.ALT.IDS] nvarchar(15) NULL, /* Versions: 1001- */
    [PERSON.ALT.IDS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_PERSON.ALT.IDS_MV] PRIMARY KEY ([PERSON.ALT.IDS_MV_ID])
    )

CREATE TABLE [input].[PERSON.EMAIL.ADDRESSES_MV] ( 
    [PERSON.EMAIL.ADDRESSES_MV_ID] int NOT NULL,
    [PERSON.EMAIL.ADDRESSES] nvarchar(100) NULL, /* Versions: 1001- */
    [PERSON.EMAIL.ADDRESSES.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_PERSON.EMAIL.ADDRESSES_MV] PRIMARY KEY ([PERSON.EMAIL.ADDRESSES_MV_ID])
    )

CREATE TABLE [input].[PERSON.EMAIL.TYPES_MV] ( 
    [PERSON.EMAIL.TYPES_MV_ID] int NOT NULL,
    [PERSON.EMAIL.TYPES] nvarchar(2) NULL, /* Versions: 1001- */
    [PERSON.EMAIL.TYPES.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_PERSON.EMAIL.TYPES_MV] PRIMARY KEY ([PERSON.EMAIL.TYPES_MV_ID])
    )

CREATE TABLE [input].[PERSONAL.PHONE.NUMBER_MV] ( 
    [PERSONAL.PHONE.NUMBER_MV_ID] int NOT NULL,
    [PERSONAL.PHONE.NUMBER] nvarchar(15) NULL, /* Versions: 1001- */
    [PERSONAL.PHONE.NUMBER.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_PERSONAL.PHONE.NUMBER_MV] PRIMARY KEY ([PERSONAL.PHONE.NUMBER_MV_ID])
    )

CREATE TABLE [input].[PERSONAL.PHONE.TYPE_MV] ( 
    [PERSONAL.PHONE.TYPE_MV_ID] int NOT NULL,
    [PERSONAL.PHONE.TYPE] nvarchar(5) NULL, /* Versions: 1001- */
    [PERSONAL.PHONE.TYPE.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_PERSONAL.PHONE.TYPE_MV] PRIMARY KEY ([PERSONAL.PHONE.TYPE_MV_ID])
    )

CREATE TABLE [input].[VETERAN.TYPE_MV] ( 
    [VETERAN.TYPE_MV_ID] int NOT NULL,
    [VETERAN.TYPE] nvarchar(5) NULL, /* Versions: 1001- */
    [VETERAN.TYPE.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_VETERAN.TYPE_MV] PRIMARY KEY ([VETERAN.TYPE_MV_ID])
    )

CREATE TABLE [input].[PERSON] ( 
    [ADDR.TYPE_MV_ID] int NULL,
    [BIRTH.DATE] date NULL, /* Versions: 1001- */
    [CITIZENSHIP] nvarchar(5) NULL, /* Versions: 1001- */
    [DECEASED.DATE] date NULL, /* Versions: 1001- */
    [DRIVER.LICENSE.NO] nvarchar(10) NULL, /* Versions: 1001- */
    [DRIVER.LICENSE.STATE] nvarchar(5) NULL, /* Versions: 1001- */
    [EMER.CONTACT.PHONE] nvarchar(20) NULL, /* Versions: 1001- */
    [ETHNIC] nvarchar(2) NULL, /* Versions: 1001- */
    [FIRST.NAME] nvarchar(25) NULL, /* Versions: 1001- */
    [GENDER] nvarchar(2) NULL, /* Versions: 1001- */
    [ID] nvarchar(10) NULL, /* Versions: 1001- */
    [LAST.NAME] nvarchar(200) NULL, /* Versions: 1001- */
    [MARITAL.STATUS] nvarchar(3) NULL, /* Versions: 1001- */
    [MIDDLE.NAME] nvarchar(25) NULL, /* Versions: 1001- */
    [NAME.HISTORY.LAST.NAME_MV_ID] int NULL,
    [PER.ETHNICS] nvarchar(5) NULL, /* Versions: 1001- */
    [PER.RACES] nvarchar(5) NULL, /* Versions: 1001- */
    [PERSON.ADD.DATE] date NULL, /* Versions: 1001- */
    [PERSON.ADD.OPERATOR] nvarchar(20) NULL, /* Versions: 1001- */
    [PERSON.ALT.IDS_MV_ID] int NULL,
    [PERSON.CHANGE.DATE] date NULL, /* Versions: 1001- */
    [PERSON.CHANGE.OPERATOR] nvarchar(20) NULL, /* Versions: 1001- */
    [PERSON.EMAIL.ADDRESSES_MV_ID] int NULL,
    [PERSON.EMAIL.TYPES_MV_ID] int NULL,
    [PERSON.OVRL.EMP.STAT] nvarchar(3) NULL, /* Versions: 1001- */
    [PERSONAL.PHONE.NUMBER_MV_ID] int NULL,
    [PERSONAL.PHONE.TYPE_MV_ID] int NULL,
    [PREFERRED.ADDRESS] int NULL, /* Versions: 1001- */
    [PRIVACY.FLAG] nvarchar(2) NULL, /* Versions: 1001- */
    [RESIDENCE.COUNTRY] nvarchar(3) NULL, /* Versions: 1001- */
    [RESIDENCE.COUNTY] nvarchar(3) NULL, /* Versions: 1001- */
    [RESIDENCE.STATE] nvarchar(3) NULL, /* Versions: 1001- */
    /* [SSN] NOTFOUND NULL, */  /* Versions: 1001- */
    [SUFFIX] nvarchar(5) NULL, /* Versions: 1001- */
    [VETERAN.TYPE_MV_ID] int NULL,
    [VETERAN.TYPE.DESC] nvarchar(50) NULL, /* Versions: 1001- */
    [VISA.TYPE] nvarchar(3) NULL, /* Versions: 1001- */
    [Current Date] date NULL, 

    CONSTRAINT [FK_PERSON_ADDR.TYPE_MV] 
        FOREIGN KEY ([ADDR.TYPE_MV_ID]) 
        REFERENCES [input].[ADDR.TYPE_MV]([ADDR.TYPE_MV_ID])
    , 

    CONSTRAINT [FK_PERSON_NAME.HISTORY.LAST.NAME_MV] 
        FOREIGN KEY ([NAME.HISTORY.LAST.NAME_MV_ID]) 
        REFERENCES [input].[NAME.HISTORY.LAST.NAME_MV]([NAME.HISTORY.LAST.NAME_MV_ID])
    , 

    CONSTRAINT [FK_PERSON_PERSON.ALT.IDS_MV] 
        FOREIGN KEY ([PERSON.ALT.IDS_MV_ID]) 
        REFERENCES [input].[PERSON.ALT.IDS_MV]([PERSON.ALT.IDS_MV_ID])
    , 

    CONSTRAINT [FK_PERSON_PERSON.EMAIL.ADDRESSES_MV] 
        FOREIGN KEY ([PERSON.EMAIL.ADDRESSES_MV_ID]) 
        REFERENCES [input].[PERSON.EMAIL.ADDRESSES_MV]([PERSON.EMAIL.ADDRESSES_MV_ID])
    , 

    CONSTRAINT [FK_PERSON_PERSON.EMAIL.TYPES_MV] 
        FOREIGN KEY ([PERSON.EMAIL.TYPES_MV_ID]) 
        REFERENCES [input].[PERSON.EMAIL.TYPES_MV]([PERSON.EMAIL.TYPES_MV_ID])
    , 

    CONSTRAINT [FK_PERSON_PERSONAL.PHONE.NUMBER_MV] 
        FOREIGN KEY ([PERSONAL.PHONE.NUMBER_MV_ID]) 
        REFERENCES [input].[PERSONAL.PHONE.NUMBER_MV]([PERSONAL.PHONE.NUMBER_MV_ID])
    , 

    CONSTRAINT [FK_PERSON_PERSONAL.PHONE.TYPE_MV] 
        FOREIGN KEY ([PERSONAL.PHONE.TYPE_MV_ID]) 
        REFERENCES [input].[PERSONAL.PHONE.TYPE_MV]([PERSONAL.PHONE.TYPE_MV_ID])
    , 

    CONSTRAINT [FK_PERSON_VETERAN.TYPE_MV] 
        FOREIGN KEY ([VETERAN.TYPE_MV_ID]) 
        REFERENCES [input].[VETERAN.TYPE_MV]([VETERAN.TYPE_MV_ID])
    )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[PST.EDUC.GOALS_MV] ( 
    [PST.EDUC.GOALS_MV_ID] int NOT NULL,
    [PST.EDUC.GOALS] nvarchar(3) NULL, /* Versions: 1001- */
    [PST.EDUC.GOALS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_PST.EDUC.GOALS_MV] PRIMARY KEY ([PST.EDUC.GOALS_MV_ID])
    )

CREATE TABLE [input].[PERSON_ST] ( 
    [PERSON.ST.ID] nvarchar(10) NULL, /* Versions: 1001- */
    [PST.CAMPUS.ORGS.MEMBER] nvarchar(50) NULL, /* Versions: 1001- */
    [PST.EDUC.GOALS_MV_ID] int NULL,
    [Current Date] date NULL, 

    CONSTRAINT [FK_PERSON_ST_m_MV] 
        FOREIGN KEY ([PST.EDUC.GOALS_MV_ID]) 
        REFERENCES [input].[PST.EDUC.GOALS_MV]([PST.EDUC.GOALS_MV_ID])
    )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[VAL.ACTION.CODE1_MV] ( 
    [VAL.ACTION.CODE1_MV_ID] int NOT NULL,
    [VAL.ACTION.CODE1] int NULL, /* Versions: 1001- */
    [VAL.ACTION.CODE1.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_VAL.ACTION.CODE1_MV] PRIMARY KEY ([VAL.ACTION.CODE1_MV_ID])
    )

CREATE TABLE [input].[VAL.ACTION.CODE2_MV] ( 
    [VAL.ACTION.CODE2_MV_ID] int NOT NULL,
    [VAL.ACTION.CODE2] int NULL, /* Versions: 1001- */
    [VAL.ACTION.CODE2.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_VAL.ACTION.CODE2_MV] PRIMARY KEY ([VAL.ACTION.CODE2_MV_ID])
    )

CREATE TABLE [input].[VAL.ACTION.CODE3_MV] ( 
    [VAL.ACTION.CODE3_MV_ID] int NOT NULL,
    [VAL.ACTION.CODE3] int NULL, /* Versions: 1001- */
    [VAL.ACTION.CODE3.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_VAL.ACTION.CODE3_MV] PRIMARY KEY ([VAL.ACTION.CODE3_MV_ID])
    )

CREATE TABLE [input].[VAL.ACTION.CODE4_MV] ( 
    [VAL.ACTION.CODE4_MV_ID] int NOT NULL,
    [VAL.ACTION.CODE4] int NULL, /* Versions: 1001- */
    [VAL.ACTION.CODE4.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_VAL.ACTION.CODE4_MV] PRIMARY KEY ([VAL.ACTION.CODE4_MV_ID])
    )

CREATE TABLE [input].[VAL.EXTERNAL.REPRESENTATION_MV] ( 
    [VAL.EXTERNAL.REPRESENTATION_MV_ID] int NOT NULL,
    [VAL.EXTERNAL.REPRESENTATION] nvarchar(255) NULL, /* Versions: 1001- */
    [VAL.EXTERNAL.REPRESENTATION.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_VAL.EXTERNAL.REPRESENTATION_MV] PRIMARY KEY ([VAL.EXTERNAL.REPRESENTATION_MV_ID])
    )

CREATE TABLE [input].[VAL.INTERNAL.CODE_MV] ( 
    [VAL.INTERNAL.CODE_MV_ID] int NOT NULL,
    [VAL.INTERNAL.CODE] nvarchar(255) NULL, /* Versions: 1001- */
    [VAL.INTERNAL.CODE.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_VAL.INTERNAL.CODE_MV] PRIMARY KEY ([VAL.INTERNAL.CODE_MV_ID])
    )

CREATE TABLE [input].[VAL.MINIMUM.INPUT.STRING_MV] ( 
    [VAL.MINIMUM.INPUT.STRING_MV_ID] int NOT NULL,
    [VAL.MINIMUM.INPUT.STRING] nvarchar(255) NULL, /* Versions: 1001- */
    [VAL.MINIMUM.INPUT.STRING.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_VAL.MINIMUM.INPUT.STRING_MV] PRIMARY KEY ([VAL.MINIMUM.INPUT.STRING_MV_ID])
    )

CREATE TABLE [input].[ST_VALCODES] ( 
    [ID] nvarchar(50) NULL, /* Versions: 1001- */
    [VAL.ACTION.CODE1_MV_ID] int NULL,
    [VAL.ACTION.CODE2_MV_ID] int NULL,
    [VAL.ACTION.CODE3_MV_ID] int NULL,
    [VAL.ACTION.CODE4_MV_ID] int NULL,
    [VAL.CODE.LENGTH] int NULL, /* Versions: 1001- */
    [VAL.EXTERNAL.REPRESENTATION_MV_ID] int NULL,
    [VAL.INTERNAL.CODE_MV_ID] int NULL,
    [VAL.MINIMUM.INPUT.STRING_MV_ID] int NULL,
    [VAL.NO.MOD] nvarchar(1) NULL, /* Versions: 1001- */
    /* [VAL.PURPOSE] nvarchar(32000) NULL, */  /* Versions: 1001- */
    [VAL.ZERO.FILL] nvarchar(1) NULL, /* Versions: 1001- */
    [VALCODE.ID] nvarchar(50) NULL, /* Versions: 1001- */
    [VALCODES.ADD.DATE] date NULL, /* Versions: 1001- */
    [VALCODES.ADD.OPERATOR] nvarchar(20) NULL, /* Versions: 1001- */
    [VALCODES.CHANGE.DATE] date NULL, /* Versions: 1001- */
    [VALCODES.CHANGE.OPERATOR] nvarchar(20) NULL, /* Versions: 1001- */
    [VALCODES.MODULES] nvarchar(5) NULL, /* Versions: 1001- */
    [VALCODES.RELEASE.STATUS] nvarchar(2) NULL, /* Versions: 1001- */
    [Current Date] date NULL, 

    CONSTRAINT [FK_ST_VALCODES_VAL.ACTION.CODE1_MV] 
        FOREIGN KEY ([VAL.ACTION.CODE1_MV_ID]) 
        REFERENCES [input].[VAL.ACTION.CODE1_MV]([VAL.ACTION.CODE1_MV_ID])
    , 

    CONSTRAINT [FK_ST_VALCODES_VAL.ACTION.CODE2_MV] 
        FOREIGN KEY ([VAL.ACTION.CODE2_MV_ID]) 
        REFERENCES [input].[VAL.ACTION.CODE2_MV]([VAL.ACTION.CODE2_MV_ID])
    , 

    CONSTRAINT [FK_ST_VALCODES_VAL.ACTION.CODE3_MV] 
        FOREIGN KEY ([VAL.ACTION.CODE3_MV_ID]) 
        REFERENCES [input].[VAL.ACTION.CODE3_MV]([VAL.ACTION.CODE3_MV_ID])
    , 

    CONSTRAINT [FK_ST_VALCODES_VAL.ACTION.CODE4_MV] 
        FOREIGN KEY ([VAL.ACTION.CODE4_MV_ID]) 
        REFERENCES [input].[VAL.ACTION.CODE4_MV]([VAL.ACTION.CODE4_MV_ID])
    , 

    CONSTRAINT [FK_ST_VALCODES_VAL.EXTERNAL.REPRESENTATION_MV] 
        FOREIGN KEY ([VAL.EXTERNAL.REPRESENTATION_MV_ID]) 
        REFERENCES [input].[VAL.EXTERNAL.REPRESENTATION_MV]([VAL.EXTERNAL.REPRESENTATION_MV_ID])
    , 

    CONSTRAINT [FK_ST_VALCODES_VAL.INTERNAL.CODE_MV] 
        FOREIGN KEY ([VAL.INTERNAL.CODE_MV_ID]) 
        REFERENCES [input].[VAL.INTERNAL.CODE_MV]([VAL.INTERNAL.CODE_MV_ID])
    , 

    CONSTRAINT [FK_ST_VALCODES_VAL.MINIMUM.INPUT.STRING_MV] 
        FOREIGN KEY ([VAL.MINIMUM.INPUT.STRING_MV_ID]) 
        REFERENCES [input].[VAL.MINIMUM.INPUT.STRING_MV]([VAL.MINIMUM.INPUT.STRING_MV_ID])
    )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[STATES] ( 
    [ID] nvarchar(3) NULL, /* Versions: 1001- */
    [ST.COUNTRY] nvarchar(100) NULL, /* Versions: 1001- */
    [ST.DESC] nvarchar(50) NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[STC.CEUS_MV] ( 
    [STC.CEUS_MV_ID] int NOT NULL,
    [STC.CEUS] nvarchar(10) NULL, /* Versions: 1001- */
    [STC.CEUS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STC.CEUS_MV] PRIMARY KEY ([STC.CEUS_MV_ID])
    )

CREATE TABLE [input].[STC.DEPTS_MV] ( 
    [STC.DEPTS_MV_ID] int NOT NULL,
    [STC.DEPTS] nvarchar(10) NULL, /* Versions: 1001- */
    [STC.DEPTS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STC.DEPTS_MV] PRIMARY KEY ([STC.DEPTS_MV_ID])
    )

CREATE TABLE [input].[STC.STATUS_MV] ( 
    [STC.STATUS_MV_ID] int NOT NULL,
    [STC.STATUS] nvarchar(2) NULL, /* Versions: 1001- */
    [STC.STATUS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STC.STATUS_MV] PRIMARY KEY ([STC.STATUS_MV_ID])
    )

CREATE TABLE [input].[STC.STATUS.DATE_MV] ( 
    [STC.STATUS.DATE_MV_ID] int NOT NULL,
    [STC.STATUS.DATE] date NULL, /* Versions: 1001- */
    [STC.STATUS.DATE.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STC.STATUS.DATE_MV] PRIMARY KEY ([STC.STATUS.DATE_MV_ID])
    )

CREATE TABLE [input].[STC.STATUS.REASON_MV] ( 
    [STC.STATUS.REASON_MV_ID] int NOT NULL,
    [STC.STATUS.REASON] nvarchar(2) NULL, /* Versions: 1001- */
    [STC.STATUS.REASON.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STC.STATUS.REASON_MV] PRIMARY KEY ([STC.STATUS.REASON_MV_ID])
    )

CREATE TABLE [input].[STC.STATUS.TIME_MV] ( 
    [STC.STATUS.TIME_MV_ID] int NOT NULL,
    [STC.STATUS.TIME] int NULL, /* Versions: 1001- */
    [STC.STATUS.TIME.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STC.STATUS.TIME_MV] PRIMARY KEY ([STC.STATUS.TIME_MV_ID])
    )

CREATE TABLE [input].[STUDENT_ACAD_CRED] ( 
    [STC.ACAD.LEVEL] nvarchar(3) NULL, /* Versions: 1001- */
    [STC.CEUS_MV_ID] int NULL,
    [STC.CMPL.CEUS] decimal(9,2) NULL, /* Versions: 1001- */
    [STC.CMPL.CRED] decimal(9,2) NULL, /* Versions: 1001- */
    [STC.COMMENTS] nvarchar(255) NULL, /* Versions: 1001- */
    [STC.COURSE] nvarchar(10) NULL, /* Versions: 1001- */
    [STC.COURSE.LEVEL] nvarchar(5) NULL, /* Versions: 1001- */
    [STC.COURSE.NAME] nvarchar(10) NULL, /* Versions: 1001- */
    [STC.CRED] decimal(9,2) NULL, /* Versions: 1001- */
    [STC.CRED.TYPE] nvarchar(5) NULL, /* Versions: 1001- */
    [STC.CUM.CONTRIB.CMPL.CRED] decimal(9,2) NULL, /* Versions: 1001- */
    [STC.DEPTS_MV_ID] int NULL,
    [STC.END.DATE] date NULL, /* Versions: 1001- */
    [STC.FINAL.GRADE] int NULL, /* Versions: 1001- */
    [STC.GRADE.PTS] decimal(9,2) NULL, /* Versions: 1001- */
    [STC.GRADE.SCHEME] nvarchar(5) NULL, /* Versions: 1001- */
    [STC.PERSON.ID] nvarchar(10) NULL, /* Versions: 1001- */
    [STC.REPORTING.TERM] nvarchar(7) NULL, /* Versions: 1001- */
    [STC.SECTION.NO] nvarchar(5) NULL, /* Versions: 1001- */
    [STC.START.DATE] date NULL, /* Versions: 1001- */
    [STC.STATUS_MV_ID] int NULL,
    [STC.STATUS.DATE_MV_ID] int NULL,
    [STC.STATUS.REASON_MV_ID] int NULL,
    [STC.STATUS.TIME_MV_ID] int NULL,
    [STC.STUDENT.COURSE.SEC] int NULL, /* Versions: 1001- */
    [STC.STUDENT.EQUIV.EVAL] int NULL, /* Versions: 1001- */
    [STC.SUBJECT] nvarchar(5) NULL, /* Versions: 1001- */
    [STC.TERM] nvarchar(7) NULL, /* Versions: 1001- */
    [STC.TITLE] nvarchar(100) NULL, /* Versions: 1001- */
    [STC.VERIFIED.GRADE] int NULL, /* Versions: 1001- */
    [STC.VERIFIED.GRADE.CHGOPR] nvarchar(20) NULL, /* Versions: 1001- */
    [STC.VERIFIED.GRADE.DATE] date NULL, /* Versions: 1001- */
    [STUDENT.ACAD.CRED.ID] int NULL, /* Versions: 1001- */
    [Current Date] date NULL, 

    CONSTRAINT [FK_STUDENT_ACAD_CRED_STC.CEUS_MV] 
        FOREIGN KEY ([STC.CEUS_MV_ID]) 
        REFERENCES [input].[STC.CEUS_MV]([STC.CEUS_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_ACAD_CRED_STC.DEPTS_MV] 
        FOREIGN KEY ([STC.DEPTS_MV_ID]) 
        REFERENCES [input].[STC.DEPTS_MV]([STC.DEPTS_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_ACAD_CRED_STC.STATUS_MV] 
        FOREIGN KEY ([STC.STATUS_MV_ID]) 
        REFERENCES [input].[STC.STATUS_MV]([STC.STATUS_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_ACAD_CRED_STC.STATUS.DATE_MV] 
        FOREIGN KEY ([STC.STATUS.DATE_MV_ID]) 
        REFERENCES [input].[STC.STATUS.DATE_MV]([STC.STATUS.DATE_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_ACAD_CRED_STC.STATUS.REASON_MV] 
        FOREIGN KEY ([STC.STATUS.REASON_MV_ID]) 
        REFERENCES [input].[STC.STATUS.REASON_MV]([STC.STATUS.REASON_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_ACAD_CRED_STC.STATUS.TIME_MV] 
        FOREIGN KEY ([STC.STATUS.TIME_MV_ID]) 
        REFERENCES [input].[STC.STATUS.TIME_MV]([STC.STATUS.TIME_MV_ID])
    )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[STA.COURSE.SEC_MV] ( 
    [STA.COURSE.SEC_MV_ID] int NOT NULL,
    [STA.COURSE.SEC] nvarchar(10) NULL, /* Versions: 1001- */
    [STA.COURSE.SEC.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STA.COURSE.SEC_MV] PRIMARY KEY ([STA.COURSE.SEC_MV_ID])
    )

CREATE TABLE [input].[STA.STUDENT.ACAD.CRED_MV] ( 
    [STA.STUDENT.ACAD.CRED_MV_ID] int NOT NULL,
    [STA.STUDENT.ACAD.CRED] nvarchar(10) NULL, /* Versions: 1001- */
    [STA.STUDENT.ACAD.CRED.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STA.STUDENT.ACAD.CRED_MV] PRIMARY KEY ([STA.STUDENT.ACAD.CRED_MV_ID])
    )

CREATE TABLE [input].[STA.TERMS_MV] ( 
    [STA.TERMS_MV_ID] int NOT NULL,
    [STA.TERMS] nvarchar(7) NULL, /* Versions: 1001- */
    [STA.TERMS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STA.TERMS_MV] PRIMARY KEY ([STA.TERMS_MV_ID])
    )

CREATE TABLE [input].[STUDENT_ACAD_LEVELS] ( 
    [STA.ACAD.LEVEL] nvarchar(5) NULL, /* Versions: 1001- */
    [STA.ACAD.PROGRAMS] nvarchar(100) NULL, /* Versions: 1001- */
    [STA.ADMIT.STATUS] nvarchar(2) NULL, /* Versions: 1001- */
    [STA.COURSE.SEC_MV_ID] int NULL,
    [STA.FED.COHORT.GROUP] nvarchar(7) NULL, /* Versions: 1001- */
    [STA.START.TERM] nvarchar(7) NULL, /* Versions: 1001- */
    [STA.STUDENT] nvarchar(10) NULL, /* Versions: 1001- */
    [STA.STUDENT.ACAD.CRED_MV_ID] int NULL,
    [STA.TERMS_MV_ID] int NULL,
    [Current Date] date NULL, 

    CONSTRAINT [FK_STUDENT_ACAD_LEVELS_STA.COURSE.SEC_MV] 
        FOREIGN KEY ([STA.COURSE.SEC_MV_ID]) 
        REFERENCES [input].[STA.COURSE.SEC_MV]([STA.COURSE.SEC_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_ACAD_LEVELS_STA.STUDENT.ACAD.CRED_MV] 
        FOREIGN KEY ([STA.STUDENT.ACAD.CRED_MV_ID]) 
        REFERENCES [input].[STA.STUDENT.ACAD.CRED_MV]([STA.STUDENT.ACAD.CRED_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_ACAD_LEVELS_STA.TERMS_MV] 
        FOREIGN KEY ([STA.TERMS_MV_ID]) 
        REFERENCES [input].[STA.TERMS_MV]([STA.TERMS_MV_ID])
    )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[STUDENT_COURSE_SEC] ( 
    [SCS.COURSE.SECTION] int NULL, /* Versions: 1001- */
    [SCS.REG.METHOD] nvarchar(10) NULL, /* Versions: 1001- */
    [SCS.STUDENT.ACAD.CRED] nvarchar(10) NULL, /* Versions: 1001- */
    [STUDENT.COURSE.SEC.ID] int NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[STUDENT_NON_COURSES] ( 
    [STNC.CATEGORY] nvarchar(5) NULL, /* Versions: 1001- */
    [STNC.END.DATE] date NULL, /* Versions: 1001- */
    [STNC.NON.COURSE] nvarchar(20) NULL, /* Versions: 1001- */
    [STNC.PERSON.ID] nvarchar(10) NULL, /* Versions: 1001- */
    [STNC.SCORE] int NULL, /* Versions: 1001- */
    [STNC.SOURCE] nvarchar(5) NULL, /* Versions: 1001- */
    [STNC.START.DATE] date NULL, /* Versions: 1001- */
    /* [STNC.STATUS]  NULL, */  /* Versions: 1001- */
    /* [STNC.STATUS.DATE]  NULL, */  /* Versions: 1001- */
    [STNC.TITLE] nvarchar(100) NULL, /* Versions: 1001- */
    [STUDENT.NON.COURSES.ID] int NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[STPR.EVAL.MAJOR.GPA_MV] ( 
    [STPR.EVAL.MAJOR.GPA_MV_ID] int NOT NULL,
    [STPR.EVAL.MAJOR.GPA] decimal(9,2) NULL, /* Versions: 1001- */
    [STPR.EVAL.MAJOR.GPA.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STPR.EVAL.MAJOR.GPA_MV] PRIMARY KEY ([STPR.EVAL.MAJOR.GPA_MV_ID])
    )

CREATE TABLE [input].[STPR.STATUS_MV] ( 
    [STPR.STATUS_MV_ID] int NOT NULL,
    [STPR.STATUS] nvarchar(2) NULL, /* Versions: 1001- */
    [STPR.STATUS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STPR.STATUS_MV] PRIMARY KEY ([STPR.STATUS_MV_ID])
    )

CREATE TABLE [input].[STPR.STATUS.CHGOPR_MV] ( 
    [STPR.STATUS.CHGOPR_MV_ID] int NOT NULL,
    [STPR.STATUS.CHGOPR] nvarchar(20) NULL, /* Versions: 1001- */
    [STPR.STATUS.CHGOPR.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STPR.STATUS.CHGOPR_MV] PRIMARY KEY ([STPR.STATUS.CHGOPR_MV_ID])
    )

CREATE TABLE [input].[STPR.STATUS.DATE_MV] ( 
    [STPR.STATUS.DATE_MV_ID] int NOT NULL,
    [STPR.STATUS.DATE] date NULL, /* Versions: 1001- */
    [STPR.STATUS.DATE.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STPR.STATUS.DATE_MV] PRIMARY KEY ([STPR.STATUS.DATE_MV_ID])
    )

CREATE TABLE [input].[STUDENT_PROGRAMS] ( 
    [STPR.ACAD.PROGRAM] nvarchar(10) NULL, /* Versions: 1001- */
    [STPR.ADMIT.STATUS] nvarchar(1) NULL, /* Versions: 1001- */
    [STPR.CATALOG] int NULL, /* Versions: 1001- */
    [STPR.DEPT] nvarchar(5) NULL, /* Versions: 1001- */
    [STPR.END.DATE] date NULL, /* Versions: 1001- */
    [STPR.EVAL.MAJOR.GPA_MV_ID] int NULL,
    [STPR.START.DATE] date NULL, /* Versions: 1001- */
    [STPR.STATUS_MV_ID] int NULL,
    [STPR.STATUS.CHGOPR_MV_ID] int NULL,
    [STPR.STATUS.DATE_MV_ID] int NULL,
    [STPR.STUDENT] nvarchar(10) NULL, /* Versions: 1001- */
    [STPR.STUDENT.ED.PLAN] nvarchar(255) NULL, /* Versions: 1001- */
    [STPR.USER1] nvarchar(1) NULL, /* Versions: 1001- */
    [Current Date] date NULL, 

    CONSTRAINT [FK_STUDENT_PROGRAMS_STPR.EVAL.MAJOR.GPA_MV] 
        FOREIGN KEY ([STPR.EVAL.MAJOR.GPA_MV_ID]) 
        REFERENCES [input].[STPR.EVAL.MAJOR.GPA_MV]([STPR.EVAL.MAJOR.GPA_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_PROGRAMS_STPR.STATUS_MV] 
        FOREIGN KEY ([STPR.STATUS_MV_ID]) 
        REFERENCES [input].[STPR.STATUS_MV]([STPR.STATUS_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_PROGRAMS_STPR.STATUS.CHGOPR_MV] 
        FOREIGN KEY ([STPR.STATUS.CHGOPR_MV_ID]) 
        REFERENCES [input].[STPR.STATUS.CHGOPR_MV]([STPR.STATUS.CHGOPR_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_PROGRAMS_STPR.STATUS.DATE_MV] 
        FOREIGN KEY ([STPR.STATUS.DATE_MV_ID]) 
        REFERENCES [input].[STPR.STATUS.DATE_MV]([STPR.STATUS.DATE_MV_ID])
    )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[STUDENT_STANDINGS] ( 
    /* [STS.TYPE] NOTFOUND NULL, */ /* Versions: 1001- */
    /* [STUDENT.STANDINGS.ID] NOTFOUND NULL, */ /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[STTR.ACTIVE.PROGRAMS_MV] ( 
    [STTR.ACTIVE.PROGRAMS_MV_ID] int NOT NULL,
    [STTR.ACTIVE.PROGRAMS] nvarchar(10) NULL, /* Versions: 1001- */
    [STTR.ACTIVE.PROGRAMS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STTR.ACTIVE.PROGRAMS_MV] PRIMARY KEY ([STTR.ACTIVE.PROGRAMS_MV_ID])
    )

CREATE TABLE [input].[XSTTR.PROGRAM.TITLE_MV] ( 
    [XSTTR.PROGRAM.TITLE_MV_ID] int NOT NULL,
    [XSTTR.PROGRAM.TITLE] nvarchar(255) NULL, /* Versions: 1001- */
    [XSTTR.PROGRAM.TITLE.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_XSTTR.PROGRAM.TITLE_MV] PRIMARY KEY ([XSTTR.PROGRAM.TITLE_MV_ID])
    )

CREATE TABLE [input].[XSTTR.PROGRAM.GPA_MV] ( 
    [XSTTR.PROGRAM.GPA_MV_ID] int NOT NULL,
    [XSTTR.PROGRAM.GPA] decimal(9,2) NULL, /* Versions: 1001- */
    [XSTTR.PROGRAM.GPA.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_XSTTR.PROGRAM.GPA_MV] PRIMARY KEY ([XSTTR.PROGRAM.GPA_MV_ID])
    )

CREATE TABLE [input].[STTR.STATUS_MV] ( 
    [STTR.STATUS_MV_ID] int NOT NULL,
    [STTR.STATUS] nvarchar(2) NULL, /* Versions: 1001- */
    [STTR.STATUS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STTR.STATUS_MV] PRIMARY KEY ([STTR.STATUS_MV_ID])
    )

CREATE TABLE [input].[STTR.STATUS.DATE_MV] ( 
    [STTR.STATUS.DATE_MV_ID] int NOT NULL,
    [STTR.STATUS.DATE] date NULL, /* Versions: 1001- */
    [STTR.STATUS.DATE.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STTR.STATUS.DATE_MV] PRIMARY KEY ([STTR.STATUS.DATE_MV_ID])
    )

CREATE TABLE [input].[STUDENT_TERMS] ( 
    [STUDENT.ID] nvarchar(10) NULL, /* Versions: 1001- */
    [STTR.ACTIVE.PROGRAMS_MV_ID] int NULL,
    [XSTTR.PROGRAM.TITLE_MV_ID] int NULL,
    [STTR.ACTIVE.CRD.LEVELS] decimal(9,2) NULL, /* Versions: 1001- */
    [STTR.ALL.CRED] decimal(9,2) NULL, /* Versions: 1001- */
    [STTR.CMPL.CRED] decimal(9,2) NULL, /* Versions: 1001- */
    [STTR.ACTIVE.CRED] decimal(9,2) NULL, /* Versions: 1001- */
    [STTR.STUDENT.LOAD] nvarchar(1) NULL, /* Versions: 1001- */
    [XSTTR.PROGRAM.GPA_MV_ID] int NULL,
    [STTR.CUM.GPA] decimal(9,2) NULL, /* Versions: 1001- */
    [STTR.GPA] decimal(9,2) NULL, /* Versions: 1001- */
    [STTR.STUDENT.TYPE] nvarchar(5) NULL, /* Versions: 1001- */
    [STTR.ACAD.LEVEL] nvarchar(3) NULL, /* Versions: 1001- */
    [STTR.CURRENT.STATUS] nvarchar(2) NULL, /* Versions: 1001- */
    [STTR.STATUS_MV_ID] int NULL,
    [STTR.STATUS.DATE_MV_ID] int NULL,
    [ID] nvarchar(25) NULL, /* Versions: 1001- */
    [STTR.TERM] nvarchar(7) NULL, /* Versions: 1001- */
    [Current Date] date NULL, 

    CONSTRAINT [FK_STUDENT_TERMS_STTR.ACTIVE.PROGRAMS_MV] 
        FOREIGN KEY ([STTR.ACTIVE.PROGRAMS_MV_ID]) 
        REFERENCES [input].[STTR.ACTIVE.PROGRAMS_MV]([STTR.ACTIVE.PROGRAMS_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_TERMS_XSTTR.PROGRAM.TITLE_MV] 
        FOREIGN KEY ([XSTTR.PROGRAM.TITLE_MV_ID]) 
        REFERENCES [input].[XSTTR.PROGRAM.TITLE_MV]([XSTTR.PROGRAM.TITLE_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_TERMS_XSTTR.PROGRAM.GPA_MV] 
        FOREIGN KEY ([XSTTR.PROGRAM.GPA_MV_ID]) 
        REFERENCES [input].[XSTTR.PROGRAM.GPA_MV]([XSTTR.PROGRAM.GPA_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_TERMS_STTR.STATUS_MV] 
        FOREIGN KEY ([STTR.STATUS_MV_ID]) 
        REFERENCES [input].[STTR.STATUS_MV]([STTR.STATUS_MV_ID])
    , 

    CONSTRAINT [FK_STUDENT_TERMS_STTR.STATUS.DATE_MV] 
        FOREIGN KEY ([STTR.STATUS.DATE_MV_ID]) 
        REFERENCES [input].[STTR.STATUS.DATE_MV]([STTR.STATUS.DATE_MV_ID])
    )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[STU.ACAD.LEVELS_MV] ( 
    [STU.ACAD.LEVELS_MV_ID] int NOT NULL,
    [STU.ACAD.LEVELS] nvarchar(3) NULL, /* Versions: 1001- */
    [STU.ACAD.LEVELS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STU.ACAD.LEVELS_MV] PRIMARY KEY ([STU.ACAD.LEVELS_MV_ID])
    )

CREATE TABLE [input].[STU.ACAD.PROGRAMS_MV] ( 
    [STU.ACAD.PROGRAMS_MV_ID] int NOT NULL,
    [STU.ACAD.PROGRAMS] nvarchar(10) NULL, /* Versions: 1001- */
    [STU.ACAD.PROGRAMS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STU.ACAD.PROGRAMS_MV] PRIMARY KEY ([STU.ACAD.PROGRAMS_MV_ID])
    )

CREATE TABLE [input].[STU.RESIDENCY.STATUS_MV] ( 
    [STU.RESIDENCY.STATUS_MV_ID] int NOT NULL,
    [STU.RESIDENCY.STATUS] nvarchar(3) NULL, /* Versions: 1001- */
    [STU.RESIDENCY.STATUS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STU.RESIDENCY.STATUS_MV] PRIMARY KEY ([STU.RESIDENCY.STATUS_MV_ID])
    )

CREATE TABLE [input].[STU.RESIDENCY.STATUS.DATE_MV] ( 
    [STU.RESIDENCY.STATUS.DATE_MV_ID] int NOT NULL,
    [STU.RESIDENCY.STATUS.DATE] date NULL, /* Versions: 1001- */
    [STU.RESIDENCY.STATUS.DATE.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STU.RESIDENCY.STATUS.DATE_MV] PRIMARY KEY ([STU.RESIDENCY.STATUS.DATE_MV_ID])
    )

CREATE TABLE [input].[STU.STANDINGS_MV] ( 
    [STU.STANDINGS_MV_ID] int NOT NULL,
    [STU.STANDINGS] int NULL, /* Versions: 1001- */
    [STU.STANDINGS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STU.STANDINGS_MV] PRIMARY KEY ([STU.STANDINGS_MV_ID])
    )

CREATE TABLE [input].[STU.TERMS_MV] ( 
    [STU.TERMS_MV_ID] int NOT NULL,
    [STU.TERMS] nvarchar(7) NULL, /* Versions: 1001- */
    [STU.TERMS.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STU.TERMS_MV] PRIMARY KEY ([STU.TERMS_MV_ID])
    )

CREATE TABLE [input].[STU.TYPE.DATES_MV] ( 
    [STU.TYPE.DATES_MV_ID] int NOT NULL,
    [STU.TYPE.DATES] date NULL, /* Versions: 1001- */
    [STU.TYPE.DATES.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STU.TYPE.DATES_MV] PRIMARY KEY ([STU.TYPE.DATES_MV_ID])
    )

CREATE TABLE [input].[STU.TYPES_MV] ( 
    [STU.TYPES_MV_ID] int NOT NULL,
    [STU.TYPES] nvarchar(5) NULL, /* Versions: 1001- */
    [STU.TYPES.INDEX.CCDW] int NULL, /* Versions: 1001- */
    [Current Date] date NULL,

    CONSTRAINT [PK_STU.TYPES_MV] PRIMARY KEY ([STU.TYPES_MV_ID])
    )

CREATE TABLE [input].[STUDENTS] ( 
    [STU.ACAD.LEVELS_MV_ID] int NULL,
    [STU.ACAD.PROGRAMS_MV_ID] int NULL,
    [STU.DEFAULT.PLANNING.PROGRAM] nvarchar(50) NULL, /* Versions: 1001- */
    [STU.RESIDENCY.STATUS_MV_ID] int NULL,
    [STU.RESIDENCY.STATUS.DATE_MV_ID] int NULL,
    [STU.STANDINGS_MV_ID] int NULL,
    [STU.TERMS_MV_ID] int NULL,
    [STU.TYPE.DATES_MV_ID] int NULL,
    [STU.TYPES_MV_ID] int NULL,
    [STUDENTS.ID] nvarchar(10) NULL, /* Versions: 1001- */
    [Current Date] date NULL, 

    CONSTRAINT [FK_STUDENTS_STU.ACAD.LEVELS_MV] 
        FOREIGN KEY ([STU.ACAD.LEVELS_MV_ID]) 
        REFERENCES [input].[STU.ACAD.LEVELS_MV]([STU.ACAD.LEVELS_MV_ID])
    , 

    CONSTRAINT [FK_STUDENTS_STU.ACAD.PROGRAMS_MV] 
        FOREIGN KEY ([STU.ACAD.PROGRAMS_MV_ID]) 
        REFERENCES [input].[STU.ACAD.PROGRAMS_MV]([STU.ACAD.PROGRAMS_MV_ID])
    , 

    CONSTRAINT [FK_STUDENTS_STU.RESIDENCY.STATUS_MV] 
        FOREIGN KEY ([STU.RESIDENCY.STATUS_MV_ID]) 
        REFERENCES [input].[STU.RESIDENCY.STATUS_MV]([STU.RESIDENCY.STATUS_MV_ID])
    , 

    CONSTRAINT [FK_STUDENTS_STU.RESIDENCY.STATUS.DATE_MV] 
        FOREIGN KEY ([STU.RESIDENCY.STATUS.DATE_MV_ID]) 
        REFERENCES [input].[STU.RESIDENCY.STATUS.DATE_MV]([STU.RESIDENCY.STATUS.DATE_MV_ID])
    , 

    CONSTRAINT [FK_STUDENTS_STU.STANDINGS_MV] 
        FOREIGN KEY ([STU.STANDINGS_MV_ID]) 
        REFERENCES [input].[STU.STANDINGS_MV]([STU.STANDINGS_MV_ID])
    , 

    CONSTRAINT [FK_STUDENTS_STU.TERMS_MV] 
        FOREIGN KEY ([STU.TERMS_MV_ID]) 
        REFERENCES [input].[STU.TERMS_MV]([STU.TERMS_MV_ID])
    , 

    CONSTRAINT [FK_STUDENTS_STU.TYPE.DATES_MV] 
        FOREIGN KEY ([STU.TYPE.DATES_MV_ID]) 
        REFERENCES [input].[STU.TYPE.DATES_MV]([STU.TYPE.DATES_MV_ID])
    , 

    CONSTRAINT [FK_STUDENTS_STU.TYPES_MV] 
        FOREIGN KEY ([STU.TYPES_MV_ID]) 
        REFERENCES [input].[STU.TYPES_MV]([STU.TYPES_MV_ID])
    )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[TERMS] ( 
    [TERMS.ID] nvarchar(7) NULL, /* Versions: 1001- */
    [TERM.DESC] nvarchar(20) NULL, /* Versions: 1001- */
    [TERM.START.DATE] date NULL, /* Versions: 1001- */
    [TERM.CENSUS.DATE] date NULL, /* Versions: 1001- */
    [TERM.END.DATE] date NULL, /* Versions: 1001- */
    [TERM.REPORTING.YEAR] int NULL, /* Versions: 1001- */
    [TERM.COMMENCEMENT.DATE] date NULL, /* Versions: 1001- */
    [TERM.DROP.START.DATE] date NULL, /* Versions: 1001- */
    [TERM.DROP.END.DATE] date NULL, /* Versions: 1001- */
    [TERM.REG.START.DATE] date NULL, /* Versions: 1001- */
    [TERM.REG.END.DATE] date NULL, /* Versions: 1001- */
    [Current Date] date NULL )

/* --------------------------------------------------------------------------------------------*/
CREATE TABLE [input].[XNC_PERSON] ( 
    [XNC.ECON.DISADVANTAGED.FLAG] nvarchar(1) NULL, /* Versions: 1001- */
    [XNC.EDU.ENTRY.LEVEL] int NULL, /* Versions: 1001- */
    /* [XNC.EDUCATIONAL.LEVEL]  NULL, */  /* Versions: 1001- */
    [XNC.FATHER.DEGREE.FLAG] nvarchar(1) NULL, /* Versions: 1001- */
    [XNC.HEAD.HOUSEHOLD.FLAG] nvarchar(1) NULL, /* Versions: 1001- */
    [XNC.HIGH.SCHOOL.TRACK] nvarchar(3) NULL, /* Versions: 1001- */
    [XNC.INMATE.FLAG] nvarchar(1) NULL, /* Versions: 1001- */
    [XNC.LIMITED.ENGLISH.FLAG] nvarchar(1) NULL, /* Versions: 1001- */
    [XNC.MOTHER.DEGREE.FLAG] nvarchar(1) NULL, /* Versions: 1001- */
    [XNC.PERSON.ID] nvarchar(10) NULL, /* Versions: 1001- */
    [XNC.SINGLE.PARENT.FLAG] nvarchar(1) NULL, /* Versions: 1001- */
    [Current Date] date NULL )
