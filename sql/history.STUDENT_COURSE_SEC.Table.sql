USE [IERG]
GO
/****** Object:  Table [history].[STUDENT_COURSE_SEC]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[STUDENT_COURSE_SEC](
	[STUDENT.COURSE.SEC.ID] [varchar](10) NOT NULL,
	[STC.PERSON.ID] [varchar](10) NULL,
	[SCS.TERM] [varchar](7) NULL,
	[SCS.REG.METHOD] [varchar](30) NULL,
	[SCS.STUDENT.ACAD.CRED] [varchar](10) NULL,
	[XSCS.COUNT.FOR.FTE] [varchar](3) NULL,
	[SCS.AR.BALANCE] [numeric](10, 2) NULL,
	[SCS.REG.TOTAL.BALANCE] [numeric](14, 2) NULL,
	[SCS.REG.TOTAL.PAYMENT] [varchar](14) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_STUDENT_COURSE_SEC] PRIMARY KEY CLUSTERED 
(
	[STUDENT.COURSE.SEC.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
