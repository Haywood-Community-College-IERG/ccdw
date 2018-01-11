USE [IERG]
GO
/****** Object:  Table [history].[COURSES]    Script Date: 1/11/2018 10:12:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[COURSES](
	[COURSES.ID] [varchar](10) NOT NULL,
	[CRS.NAME] [varchar](15) NULL,
	[CRS.SUBJECT] [varchar](40) NULL,
	[CRS.NO] [varchar](7) NULL,
	[CRS.TITLE] [varchar](250) NULL,
	[CRS.SHORT.TITLE] [varchar](30) NULL,
	[CRS.DESC] [varchar](2500) NULL,
	[CRS.MIN.CRED] [numeric](8, 2) NULL,
	[CRS.MAX.CRED] [numeric](8, 2) NULL,
	[CRS.CEUS] [numeric](6, 2) NULL,
	[CRS.CIP] [varchar](35) NULL,
	[CRS.SCHOOLS] [varchar](50) NULL,
	[CRS.DIVISIONS] [varchar](35) NULL,
	[CRS.COREQ.COURSES] [varchar](8000) NULL,
	[CRS.COREQ.COURSES.REQD.FLAG] [varchar](8000) NULL,
	[CRS.DEPTS] [varchar](8000) NULL,
	[CRS.DEPT.PCTS] [varchar](8000) NULL,
	[CRS.COURSE.TYPES] [varchar](250) NULL,
	[CRS.STATUS] [varchar](8000) NULL,
	[CRS.STATUS.DATE] [varchar](8000) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_COURSES] PRIMARY KEY CLUSTERED 
(
	[COURSES.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
