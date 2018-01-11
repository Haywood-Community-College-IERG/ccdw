USE [IERG]
GO
/****** Object:  Table [history].[COUNTIES]    Script Date: 1/11/2018 10:12:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[COUNTIES](
	[COUNTIES.ID] [varchar](7) NOT NULL,
	[CNTY.DESC] [varchar](1000) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_COUNTIES] PRIMARY KEY CLUSTERED 
(
	[COUNTIES.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
