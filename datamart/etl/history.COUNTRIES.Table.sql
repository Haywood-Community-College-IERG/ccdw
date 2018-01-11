USE [IERG]
GO
/****** Object:  Table [history].[COUNTRIES]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[COUNTRIES](
	[COUNTRIES.ID] [varchar](8) NOT NULL,
	[CTRY.DESC] [varchar](500) NULL,
	[CTRY.ISO.CODE] [varchar](2) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_COUNTRIES] PRIMARY KEY CLUSTERED 
(
	[COUNTRIES.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
