USE [IERG]
GO
/****** Object:  Table [history].[NON_COURSES]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[NON_COURSES](
	[NON.COURSES.ID] [varchar](10) NOT NULL,
	[NCRS.DESC] [varchar](500) NULL,
	[NCRS.SHORT.TITLE] [varchar](30) NULL,
	[NCRS.CAT.DESC.CC] [varchar](500) NULL,
	[NCRS.DESIRED.GRADES] [varchar](3) NULL,
	[NCRS.GRADE.SCHEME] [varchar](35) NULL,
	[NCRS.DESIRED.SCORE] [numeric](5, 0) NULL,
	[NCRS.COURSE.EQUIVS] [varchar](30) NULL,
	[NCRS.MIN.SCORE] [numeric](5, 0) NULL,
	[NCRS.MAX.SCORE] [numeric](5, 0) NULL,
	[NCRS.TYPE] [varchar](30) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_NON_COURSES] PRIMARY KEY CLUSTERED 
(
	[NON.COURSES.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
