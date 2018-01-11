USE [IERG]
GO
/****** Object:  Table [history].[CS_ACYR]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[CS_ACYR](
	[CS.STUDENT.ID] [varchar](10) NOT NULL,
	[CS.YEAR] [varchar](4) NOT NULL,
	[CS.AWARD] [varchar](100) NULL,
	[CS.FC] [varchar](7) NULL,
	[CS.VERIF.STATUS] [varchar](1) NULL,
	[CS.VERIF.DT] [date] NULL,
	[CS.VERIF.FLAGS] [varchar](6) NULL,
	[CS.HAS.ISIR] [varchar](1) NULL,
	[CS.ACYR.ADD.DATE] [date] NULL,
	[CS.ACYR.ADD.OPERATOR] [varchar](10) NULL,
	[CS.ACYR.CHANGE.DATE] [date] NULL,
	[CS.ACYR.CHANGE.OPERATOR] [varchar](10) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_CS_ACYR] PRIMARY KEY CLUSTERED 
(
	[CS.YEAR] ASC,
	[CS.STUDENT.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
