USE [IERG]
GO
/****** Object:  Table [history].[SUBJECTS]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[SUBJECTS](
	[SUBJECTS.ID] [varchar](7) NOT NULL,
	[SUBJ.DESC] [varchar](30) NULL,
	[SUBJECTS.ADDDATE] [date] NULL,
	[SUBJECTS.ADDOPR] [varchar](8) NULL,
	[SUBJECTS.CHGDATE] [date] NULL,
	[SUBJECTS.CHGOPR] [varchar](8) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_SUBJECTS] PRIMARY KEY CLUSTERED 
(
	[SUBJECTS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
