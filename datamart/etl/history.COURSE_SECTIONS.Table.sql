USE [IERG]
GO
/****** Object:  Table [history].[COURSE_SECTIONS]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[COURSE_SECTIONS](
	[COURSE.SECTIONS.ID] [varchar](21) NOT NULL,
	[SEC.TERM] [varchar](35) NULL,
	[SEC.REPORTING.TERM] [varchar](7) NULL,
	[SEC.COURSE] [varchar](15) NULL,
	[SEC.NAME] [varchar](21) NULL,
	[SEC.NO] [varchar](5) NULL,
	[SEC.USER1] [varchar](20) NULL,
	[SEC.USER2] [varchar](20) NULL,
	[SEC.USER6] [varchar](10) NULL,
	[SEC.LOCATION] [varchar](35) NULL,
	[SEC.LOCATION.DESC.CC] [varchar](100) NULL,
	[SEC.CAPACITY] [numeric](5, 0) NULL,
	[SEC.EVERY.STUDENT.COUNT] [numeric](6, 0) NULL,
	[SEC.STUDENTS.COUNT] [varchar](10) NULL,
	[SEC.AUDIT.STUDENT.COUNT] [numeric](5, 0) NULL,
	[SEC.ACAD.LEVEL] [varchar](35) NULL,
	[SEC.CRED.TYPE] [varchar](35) NULL,
	[SEC.MIN.CRED] [numeric](8, 2) NULL,
	[SEC.MAX.CRED] [numeric](8, 2) NULL,
	[SEC.BILLING.CRED] [numeric](8, 2) NULL,
	[XSEC.FTE.COUNT] [numeric](9, 0) NULL,
	[XSEC.FTE.CONTACT] [numeric](11, 2) NULL,
	[SEC.CEUS] [numeric](6, 2) NULL,
	[XSEC.FTE] [numeric](9, 2) NULL,
	[X.842.CONED.FTE] [varchar](5) NULL,
	[SEC.FUNDING.SOURCES] [varchar](30) NULL,
	[SEC.FUNDING.ACCTG.METHOD] [varchar](30) NULL,
	[SEC.BILLING.METHOD] [varchar](20) NULL,
	[SEC.FEE] [numeric](8, 2) NULL,
	[SEC.REVENUE] [numeric](7, 2) NULL,
	[SEC.CONTACT.HOURS] [varchar](8000) NULL,
	[SEC.CONTACT.MEASURES] [varchar](8000) NULL,
	[SEC.FACULTY] [varchar](500) NULL,
	[SEC.COURSE.LEVELS] [varchar](30) NULL,
	[SEC.STUDENTS] [varchar](5000) NULL,
	[SEC.STATUS.ACTION1] [varchar](2) NULL,
	[SEC.STATUS] [varchar](8000) NULL,
	[COURSE.SECTIONS.ADDDATE] [date] NULL,
	[COURSE.SECTIONS.ADDOPR] [varchar](8) NULL,
	[COURSE.SECTIONS.CHGDATE] [date] NULL,
	[COURSE.SECTIONS.CHGOPR] [varchar](8) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_COURSE_SECTIONS] PRIMARY KEY CLUSTERED 
(
	[COURSE.SECTIONS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
