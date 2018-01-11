USE [IERG]
GO
/****** Object:  Table [history].[ETHNICS]    Script Date: 1/11/2018 9:56:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[ETHNICS](
	[ETHNICS.ID] [varchar](2) NOT NULL,
	[ETH.DESC] [varchar](30) NULL,
	[ETHNICS.ADD.DATE] [date] NULL,
	[ETHNICS.ADD.OPERATOR] [varchar](8) NULL,
	[ETHNICS.CHANGE.DATE] [date] NULL,
	[ETHNICS.CHANGE.OPERATOR] [varchar](8) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_ETHNICS] PRIMARY KEY CLUSTERED 
(
	[ETHNICS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
