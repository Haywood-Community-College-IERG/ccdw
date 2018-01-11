USE [IERG]
GO
/****** Object:  Table [history].[GRADES]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[GRADES](
	[GRADES.ID] [varchar](10) NOT NULL,
	[GRD.GRADE] [varchar](3) NULL,
	[GRD.LEGEND] [varchar](30) NULL,
	[GRD.GRADE.SCHEME] [varchar](35) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_GRADES] PRIMARY KEY CLUSTERED 
(
	[GRADES.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
