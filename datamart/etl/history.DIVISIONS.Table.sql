USE [IERG]
GO
/****** Object:  Table [history].[DIVISIONS]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[DIVISIONS](
	[DIVISIONS.ID] [varchar](5) NOT NULL,
	[DIV.DESC] [varchar](500) NULL,
	[DIV.INSTITUTIONS.ID] [varchar](50) NULL,
	[DIV.TYPE] [varchar](10) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_DIVISIONS] PRIMARY KEY CLUSTERED 
(
	[DIVISIONS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
