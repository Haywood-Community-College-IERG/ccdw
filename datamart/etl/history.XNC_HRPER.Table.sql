USE [IERG]
GO
/****** Object:  Table [history].[XNC_HRPER]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[XNC_HRPER](
	[XNC.HRPER.ID] [varchar](7) NOT NULL,
	[XHRP.ACAD.LEVEL] [varchar](4) NULL,
	[ACAD.LEVEL.DESC] [varchar](max) NULL,
	[XHRP.AOI] [varchar](30) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_XNC_HRPER] PRIMARY KEY CLUSTERED 
(
	[XNC.HRPER.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
