USE [IERG]
GO
/****** Object:  Table [history].[INSTITUTIONS]    Script Date: 1/11/2018 9:56:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[INSTITUTIONS](
	[INSTITUTIONS.ID] [varchar](10) NOT NULL,
	[INST.SORT.NAME] [varchar](57) NULL,
	[INST.TYPE] [varchar](20) NULL,
	[CORP.FICE] [varchar](6) NULL,
	[INST.CEEB] [varchar](15) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_INSTITUTIONS] PRIMARY KEY CLUSTERED 
(
	[INSTITUTIONS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
