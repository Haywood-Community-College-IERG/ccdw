USE [IERG]
GO
/****** Object:  Table [history].[STUDENT_NON_COURSES]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[STUDENT_NON_COURSES](
	[STUDENT.NON.COURSES.ID] [varchar](10) NOT NULL,
	[STNC.PERSON.ID] [varchar](10) NULL,
	[STNC.NON.COURSE] [varchar](10) NULL,
	[STNC.TITLE] [varchar](30) NULL,
	[STNC.SCORE] [numeric](5, 0) NULL,
	[STNC.SUBCOMPONENT.SCORES] [varchar](8000) NULL,
	[STNC.TEST.TYPE] [varchar](20) NULL,
	[STNC.SOURCE] [varchar](30) NULL,
	[STNC.CATEGORY] [varchar](25) NULL,
	[STNC.STUDENT.EQUIV.EVAL] [varchar](10) NULL,
	[STNC.INSTITUTION] [varchar](30) NULL,
	[STNC.NON.CRS.GRADE.USE] [varchar](5) NULL,
	[STNC.STATUS] [varchar](30) NULL,
	[STNC.START.DATE] [date] NULL,
	[STNC.END.DATE] [date] NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_STUDENT_NON_COURSES] PRIMARY KEY CLUSTERED 
(
	[STUDENT.NON.COURSES.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
