USE [IERG]
GO
/****** Object:  Table [history].[CIP]    Script Date: 1/11/2018 10:12:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[CIP](
	[CIP.ID] [varchar](9) NOT NULL,
	[CIP.DESC] [varchar](75) NULL,
	[CIP.FORMER.CODES] [varchar](8000) NULL,
	[CIP.FORMER.YEAR] [varchar](8000) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_CIP] PRIMARY KEY CLUSTERED 
(
	[CIP.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
