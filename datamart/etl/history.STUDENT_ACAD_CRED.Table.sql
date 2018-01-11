USE [IERG]
GO
/****** Object:  Table [history].[STUDENT_ACAD_CRED]    Script Date: 1/11/2018 10:12:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[STUDENT_ACAD_CRED](
	[STUDENT.ACAD.CRED.ID] [varchar](10) NOT NULL,
	[STC.PERSON.ID] [varchar](10) NULL,
	[STC.TERM] [varchar](35) NULL,
	[STC.REPORTING.TERM] [varchar](35) NULL,
	[STC.COURSE] [varchar](15) NULL,
	[STC.SUBJECT] [varchar](40) NULL,
	[STC.CRS.NUMBER] [varchar](7) NULL,
	[STC.SECTION.NO] [varchar](5) NULL,
	[STC.TITLE] [varchar](500) NULL,
	[STC.COMMENTS] [varchar](500) NULL,
	[STC.COURSE.LEVEL] [varchar](30) NULL,
	[STC.ACAD.LEVEL] [varchar](35) NULL,
	[STC.CEUS] [numeric](6, 2) NULL,
	[STC.CMPL.CEUS] [numeric](6, 2) NULL,
	[X.808.DEV.CRED] [varchar](9) NULL,
	[STC.CRED] [numeric](8, 2) NULL,
	[STC.CMPL.CRED] [numeric](8, 2) NULL,
	[STC.CUM.CONTRIB.CMPL.CRED] [numeric](8, 2) NULL,
	[XSTC.COUNT.FOR.FTE.V2] [varchar](3) NULL,
	[STC.CRED.TYPE] [varchar](35) NULL,
	[STC.DEPTS] [varchar](40) NULL,
	[STC.START.DATE] [date] NULL,
	[STC.END.DATE] [date] NULL,
	[STC.GRADE.SCHEME] [varchar](35) NULL,
	[STC.COURSE.SECTION] [varchar](19) NULL,
	[STC.STUDENT.COURSE.SEC] [varchar](10) NULL,
	[STC.STUDENT.EQUIV.EVAL] [varchar](10) NULL,
	[STC.VERIFIED.GRADE.CHGOPR] [varchar](20) NULL,
	[STC.VERIFIED.GRADE.DATE] [date] NULL,
	[STC.VERIFIED.GRADE] [varchar](3) NULL,
	[STC.FINAL.GRADE] [varchar](3) NULL,
	[STC.GRADE.PTS] [numeric](9, 5) NULL,
	[STC.STATUS] [varchar](8000) NULL,
	[STC.STATUS.DATE] [varchar](8000) NULL,
	[STC.STATUS.TIME] [varchar](8000) NULL,
	[STC.STATUS.REASON] [varchar](8000) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_STUDENT_ACAD_CRED] PRIMARY KEY CLUSTERED 
(
	[STUDENT.ACAD.CRED.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
