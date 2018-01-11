USE [IERG]
GO
/****** Object:  Table [history].[PERSON_TEST]    Script Date: 1/11/2018 10:12:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[PERSON_TEST](
	[ID] [varchar](10) NOT NULL,
	[FIRST.NAME] [varchar](50) NULL,
	[MIDDLE.NAME] [varchar](50) NULL,
	[LAST.NAME] [varchar](250) NULL,
	[SUFFIX] [varchar](25) NULL,
	[NAME.HISTORY.LAST.NAME] [varchar](8000) NULL,
	[GENDER] [varchar](1) NULL,
	[BIRTH.DATE] [date] NULL,
	[DECEASED.DATE] [date] NULL,
	[MARITAL.STATUS] [varchar](1) NULL,
	[ETHNIC] [varchar](2) NULL,
	[PER.ETHNICS] [varchar](10) NULL,
	[PER.RACES] [varchar](25) NULL,
	[CITIZENSHIP] [varchar](8) NULL,
	[PERSON.ALT.IDS] [varchar](8000) NULL,
	[ADDRESS.LINES] [varchar](5000) NULL,
	[CITY] [varchar](100) NULL,
	[STATE] [varchar](30) NULL,
	[ZIP] [varchar](20) NULL,
	[ADDR.TYPE] [varchar](8000) NULL,
	[RESIDENCE.COUNTY] [varchar](30) NULL,
	[RESIDENCE.STATE] [varchar](30) NULL,
	[RESIDENCE.COUNTRY] [varchar](20) NULL,
	[EMER.CONTACT.PHONE] [varchar](12) NULL,
	[PERSON.OVRL.EMP.STAT] [varchar](25) NULL,
	[VETERAN.TYPE] [varchar](8000) NULL,
	[VETERAN.TYPE2.DESCRIPTION] [varchar](max) NULL,
	[VISA.TYPE] [varchar](30) NULL,
	[PRIVACY.FLAG] [varchar](25) NULL,
	[DIRECTORY.FLAG] [varchar](2) NULL,
	[PERSON.EMAIL.ADDRESSES] [varchar](8000) NULL,
	[PERSON.EMAIL.TYPES] [varchar](8000) NULL,
	[PERSONAL.PHONE.NUMBER] [varchar](8000) NULL,
	[PERSONAL.PHONE.TYPE] [varchar](8000) NULL,
	[PERSON.ADD.DATE] [date] NULL,
	[PERSON.ADD.OPERATOR] [varchar](10) NULL,
	[PERSON.CHANGE.DATE] [date] NULL,
	[PERSON.CHANGE.OPERATOR] [varchar](10) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
