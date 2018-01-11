USE [IERG]
GO
/****** Object:  Table [history].[ACAD_PROGRAMS]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[ACAD_PROGRAMS](
	[ACAD.PROGRAMS.ID] [varchar](20) NOT NULL,
	[ACPG.TITLE] [varchar](60) NULL,
	[ACPG.DEGREE] [varchar](5) NULL,
	[ACPG.ACAD.LEVEL] [varchar](5) NULL,
	[ACPG.TYPES] [varchar](50) NULL,
	[ACPG.MAJORS] [varchar](35) NULL,
	[ACPG.MINORS] [varchar](35) NULL,
	[ACPG.CIP] [varchar](35) NULL,
	[ACPG.CMPL.MONTHS] [varchar](3) NULL,
	[ACPG.TERM.LENGTH] [numeric](2, 0) NULL,
	[ACPG.ACCRED.EXPIRE.DATE] [date] NULL,
	[ACPG.ACAD.STANDINGS] [varchar](8000) NULL,
	[ACPG.ADDNL.CCDS] [varchar](35) NULL,
	[ACPG.ADDNL.MAJORS] [varchar](35) NULL,
	[ACPG.ADMIT.CAPACITY] [numeric](6, 0) NULL,
	[ACPG.ADMIT.RULES] [varchar](8000) NULL,
	[ACPG.APPLICATION.STATUS] [varchar](8000) NULL,
	[ACPG.ALLOW.GRADUATION.FLAG] [varchar](3) NULL,
	[ACPG.GRADE.SCHEME] [varchar](5) NULL,
	[ACPG.STUDENT.SELECT.FLAG] [varchar](1) NULL,
	[ACPG.TRANSCRIPT.GROUPING] [varchar](35) NULL,
	[ACPG.LOCATIONS] [varchar](8000) NULL,
	[ACPG.SCHOOLS] [varchar](5) NULL,
	[ACPG.DIVISIONS] [varchar](5) NULL,
	[DIV.DESC] [varchar](500) NULL,
	[ACPG.DEPTS] [varchar](25) NULL,
	[DEPTS.DESC] [varchar](30) NULL,
	[ACPG.START.DATE] [date] NULL,
	[ACPG.END.DATE] [date] NULL,
	[ACPG.CATALOGS] [varchar](500) NULL,
	[ACPG.APPROVAL.IDS] [varchar](8000) NULL,
	[ACPG.APPROVAL.AGENCY.IDS] [varchar](8000) NULL,
	[ACPG.APPROVAL.DATES] [varchar](8000) NULL,
	[ACPG.STATUS] [varchar](8000) NULL,
	[ACPG.STATUS.DATE] [varchar](8000) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_ACAD_PROGRAMS] PRIMARY KEY CLUSTERED 
(
	[ACAD.PROGRAMS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
