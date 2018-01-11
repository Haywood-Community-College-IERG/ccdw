USE [IERG]
GO
/****** Object:  Table [history].[XLE_STUDENTS]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[XLE_STUDENTS](
	[XLE.STUDENTS.ID] [varchar](10) NOT NULL,
	[XLE.AHS.NEEDED] [varchar](5) NULL,
	[XLS.AHS.COMPLETE] [varchar](max) NULL,
	[XLE.AHS.TRANS.IN] [varchar](5) NULL,
	[XLE.AHS.TRANS.DATE] [date] NULL,
	[XLE.STU.INTAKE.DATE] [varchar](8000) NULL,
	[XLE.SEPARATION.DATE] [varchar](8000) NULL,
	[XLE.TEST.CODE] [varchar](8000) NULL,
	[XLE.TEST.DATE] [varchar](8000) NULL,
	[XLE.TEST.SCORE] [varchar](8000) NULL,
	[XLE.STUDENT.DATA] [varchar](25) NULL,
	[XLE.AHS.1ST.ATTDATE] [varchar](8000) NULL,
	[XLE.AHS.1ST.COMDATE] [varchar](8000) NULL,
	[XLE.STUDENTS.ADDDATE] [date] NULL,
	[XLE.STUDENTS.ADDTIME] [time](7) NULL,
	[XLE.STUDENTS.ADDOPR] [varchar](25) NULL,
	[XLE.STUDENTS.CHGDATE] [date] NULL,
	[XLE.STUDENTS.CHGTIME] [time](7) NULL,
	[XLE.STUDENTS.CHGOPR] [varchar](25) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_XLE_STUDENTS] PRIMARY KEY CLUSTERED 
(
	[XLE.STUDENTS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
