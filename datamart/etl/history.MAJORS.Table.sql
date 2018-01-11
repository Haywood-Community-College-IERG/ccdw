USE [IERG]
GO
/****** Object:  Table [history].[MAJORS]    Script Date: 1/11/2018 10:12:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[MAJORS](
	[MAJORS.ID] [varchar](5) NOT NULL,
	[MAJ.ACTIVE.FLAG] [varchar](3) NULL,
	[MAJ.CIP] [varchar](35) NULL,
	[MAJ.DESC] [varchar](30) NULL,
	[MAJ.DIVISION] [varchar](35) NULL,
	[MAJORS.ADDDATE] [date] NULL,
	[MAJORS.ADDOPR] [varchar](8) NULL,
	[MAJORS.CHGDATE] [date] NULL,
	[MAJORS.CHGOPR] [varchar](8) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_MAJORS] PRIMARY KEY CLUSTERED 
(
	[MAJORS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
