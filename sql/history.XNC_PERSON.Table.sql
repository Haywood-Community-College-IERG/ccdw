USE [IERG]
GO
/****** Object:  Table [history].[XNC_PERSON]    Script Date: 1/11/2018 9:56:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[XNC_PERSON](
	[XNC.PERSON.ID] [varchar](10) NOT NULL,
	[XNC.EDU.ENTRY.LEVEL] [varchar](8) NULL,
	[XNC.FATHER.DEGREE.FLAG] [varchar](3) NULL,
	[XNC.MOTHER.DEGREE.FLAG] [varchar](3) NULL,
	[XNC.HEAD.HOUSEHOLD.FLAG] [varchar](3) NULL,
	[XNC.SINGLE.PARENT.FLAG] [varchar](3) NULL,
	[XNC.ECON.DISADVANTAGED.FLAG] [varchar](3) NULL,
	[XNC.LIMITED.ENGLISH.FLAG] [varchar](3) NULL,
	[XNC.INMATE.FLAG] [varchar](3) NULL,
	[XNC.HIGH.SCHOOL.TRACK] [varchar](30) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_XNC_PERSON] PRIMARY KEY CLUSTERED 
(
	[XNC.PERSON.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
