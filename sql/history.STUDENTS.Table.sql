USE [IERG]
GO
/****** Object:  Table [history].[STUDENTS]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[STUDENTS](
	[STUDENTS.ID] [varchar](10) NOT NULL,
	[STU.RESIDENCY.STATUS] [varchar](8000) NULL,
	[STU.RESIDENCY.STATUS.DATE] [varchar](8000) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_STUDENTS] PRIMARY KEY CLUSTERED 
(
	[STUDENTS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
