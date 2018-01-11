USE [IERG]
GO
/****** Object:  Table [history].[ADDRESS]    Script Date: 1/11/2018 10:12:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[ADDRESS](
	[ADDRESS.ID] [varchar](25) NOT NULL,
	[RESIDENTS] [varchar](8000) NULL,
	[ADDRESS.LINES] [varchar](5000) NULL,
	[CITY] [varchar](100) NULL,
	[STATE] [varchar](30) NULL,
	[ZIP] [varchar](20) NULL,
	[COUNTY] [varchar](50) NULL,
	[CNTY.DESC] [varchar](1000) NULL,
	[COUNTRY] [varchar](50) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_ADDRESS] PRIMARY KEY CLUSTERED 
(
	[ADDRESS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
