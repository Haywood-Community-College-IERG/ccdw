USE [IERG]
GO
/****** Object:  Table [history].[ORG_ENTITY]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[ORG_ENTITY](
	[ORG.ENTITY.ID] [varchar](10) NOT NULL,
	[OEE.USERNAME] [varchar](50) NULL,
	[OE.PREFIX] [varchar](25) NULL,
	[OE.FIRST.NAME] [varchar](25) NULL,
	[OE.MIDDLE.NAME] [varchar](25) NULL,
	[OE.LAST.NAME] [varchar](25) NULL,
	[OE.SUFFIX] [varchar](25) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_ORG_ENTITY] PRIMARY KEY CLUSTERED 
(
	[ORG.ENTITY.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
