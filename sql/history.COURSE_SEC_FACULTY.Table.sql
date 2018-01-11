USE [IERG]
GO
/****** Object:  Table [history].[COURSE_SEC_FACULTY]    Script Date: 1/11/2018 9:56:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[COURSE_SEC_FACULTY](
	[COURSE.SEC.FACULTY.ID] [varchar](10) NOT NULL,
	[CSF.FACULTY] [varchar](10) NULL,
	[XCSF.FACULTY.FTE] [numeric](11, 2) NULL,
	[CSF.FACULTY.LOAD] [numeric](6, 2) NULL,
	[CSF.FACULTY.PCT] [numeric](6, 2) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_COURSE_SEC_FACULTY] PRIMARY KEY CLUSTERED 
(
	[COURSE.SEC.FACULTY.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
