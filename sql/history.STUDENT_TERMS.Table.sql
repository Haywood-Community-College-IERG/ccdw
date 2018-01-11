USE [IERG]
GO
/****** Object:  Table [history].[STUDENT_TERMS]    Script Date: 1/11/2018 9:56:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[STUDENT_TERMS](
	[STTR.STUDENT] [varchar](10) NOT NULL,
	[STTR.TERM] [varchar](7) NOT NULL,
	[STTR.ACAD.LEVEL] [varchar](20) NOT NULL,
	[STTR.ACTIVE.PROGRAMS] [varchar](8000) NULL,
	[X.STTR.PROGRAM.TITLE] [varchar](8000) NULL,
	[STTR.START.DATE] [date] NULL,
	[STTR.FED.COHORT.GROUP] [varchar](10) NULL,
	[STTR.ACTIVE.CRD.LEVELS] [numeric](8, 2) NULL,
	[STU.CMPL.CRED] [numeric](8, 2) NULL,
	[STTR.CUM.GPA] [numeric](7, 3) NULL,
	[STTR.ALL.CRED] [numeric](8, 2) NULL,
	[STTR.CMPL.CRED] [numeric](8, 2) NULL,
	[STTR.ACTIVE.CRED] [numeric](8, 2) NULL,
	[STTR.STUDENT.LOAD] [varchar](30) NULL,
	[STTR.GPA] [numeric](7, 3) NULL,
	[STTR.STUDENT.TYPE] [varchar](5) NULL,
	[STTR.ALIEN.FLAG] [varchar](5) NULL,
	[STTR.ADMIT.STATUS] [varchar](5) NULL,
	[STTR.STATUS] [varchar](8000) NULL,
	[STTR.STATUS.DATE] [date] NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_STUDENT_TERMS] PRIMARY KEY CLUSTERED 
(
	[STTR.STUDENT] ASC,
	[STTR.TERM] ASC,
	[STTR.ACAD.LEVEL] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
