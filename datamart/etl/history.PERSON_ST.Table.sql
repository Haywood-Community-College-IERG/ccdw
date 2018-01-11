USE [IERG]
GO
/****** Object:  Table [history].[PERSON_ST]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[PERSON_ST](
	[PERSON.ST.ID] [varchar](10) NOT NULL,
	[PST.EDUC.GOALS] [varchar](8000) NULL,
	[PST.ADVISOR.NAME] [varchar](40) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_PERSON_ST] PRIMARY KEY CLUSTERED 
(
	[PERSON.ST.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
