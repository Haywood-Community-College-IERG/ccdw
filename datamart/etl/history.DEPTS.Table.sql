USE [IERG]
GO
/****** Object:  Table [history].[DEPTS]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[DEPTS](
	[DEPTS.ID] [varchar](5) NOT NULL,
	[DEPTS.INSTITUTIONS.ID] [varchar](50) NULL,
	[DEPTS.TYPE] [varchar](10) NULL,
	[DEPTS.SCHOOL] [varchar](35) NULL,
	[DEPTS.CIP] [varchar](40) NULL,
	[DEPTS.DESC] [varchar](30) NULL,
	[DEPTS.DESC.LKUP] [varchar](30) NULL,
	[DEPTS.TERMINAL.DEGREE] [varchar](35) NULL,
	[DEPTS.HEAD.ID] [varchar](40) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_DEPTS] PRIMARY KEY CLUSTERED 
(
	[DEPTS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
