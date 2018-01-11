USE [IERG]
GO
/****** Object:  Table [history].[SCHOOLS]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[SCHOOLS](
	[SCHOOLS.ID] [varchar](10) NOT NULL,
	[SCHOOLS.DESC] [varchar](500) NULL,
	[SCHOOLS.INSTITUTIONS.ID] [varchar](50) NULL,
	[SCHOOLS.DIVISIONS] [varchar](100) NULL,
	[SCHOOLS.DEPTS] [varchar](100) NULL,
	[SCHOOLS.ADD.OPERATOR] [varchar](10) NULL,
	[SCHOOLS.ADD.DATE] [date] NULL,
	[SCHOOLS.CHANGE.OPERATOR] [varchar](10) NULL,
	[SCHOOLS.CHANGE.DATE] [date] NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_SCHOOLS] PRIMARY KEY CLUSTERED 
(
	[SCHOOLS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
