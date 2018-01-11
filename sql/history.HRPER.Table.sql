USE [IERG]
GO
/****** Object:  Table [history].[HRPER]    Script Date: 1/11/2018 9:56:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[HRPER](
	[HRPER.ID] [varchar](7) NOT NULL,
	[HRP.FIRST.NAME] [varchar](15) NULL,
	[HRP.MIDDLE.NAME] [varchar](15) NULL,
	[HRP.LAST.NAME] [varchar](25) NULL,
	[HRP.MAIDEN.LAST.NAME] [varchar](25) NULL,
	[HRP.NICKNAME] [varchar](15) NULL,
	[HRP.PREFIX] [varchar](15) NULL,
	[HRP.SUFFIX] [varchar](25) NULL,
	[HRP.BIRTH.DATE] [date] NULL,
	[HRP.DECEASED.DATE] [date] NULL,
	[HRP.MARITAL.STATUS] [varchar](1) NULL,
	[HRP.PERSTAT.START.DATE] [varchar](8000) NULL,
	[HRP.PERSTAT.END.DATE] [varchar](8000) NULL,
	[HRP.PERPOS.START.DATE] [varchar](8000) NULL,
	[HRP.PERPOS.END.DATE] [varchar](8000) NULL,
	[HRP.PERLV.START.DATE] [varchar](8000) NULL,
	[HRP.PERLV.END.DATE] [varchar](8000) NULL,
	[HRP.LAST.PERIOD.PAID] [varchar](8000) NULL,
	[HRP.PERPOS.LAST.PAY.DATE] [varchar](8000) NULL,
	[HRP.PERLV.LAST.PAY.DATE] [varchar](8000) NULL,
	[HRP.EFFECT.EMPLOY.DATE] [date] NULL,
	[HRP.EFFECT.TERM.DATE] [date] NULL,
	[HRP.SERVICE.YEARS] [numeric](5, 2) NULL,
	[HRP.SERVICE.MONTHS] [numeric](5, 0) NULL,
	[X842.SERVICE.YEARS] [numeric](5, 0) NULL,
	[X842.SERVICE.YEARS2] [numeric](7, 0) NULL,
	[X.842.IS.FACULTY] [varchar](1) NULL,
	[HRP.ACTIVE.STATUS] [varchar](10) NULL,
	[HRP.CURRENT.STATUS] [varchar](18) NULL,
	[HRP.PERSTAT.STATUS] [varchar](250) NULL,
	[X.ACTIVE.STATUS] [varchar](1) NULL,
	[HRP.ADR.LINES] [varchar](100) NULL,
	[HRP.ADR.CITY] [varchar](50) NULL,
	[HRP.ADR.STATE] [varchar](2) NULL,
	[HRP.ADR.ZIP] [varchar](10) NULL,
	[HRP.PRI.DEPT1] [varchar](5) NULL,
	[HRP.PRI.DEPT.DESC] [varchar](50) NULL,
	[XHRP.XNC.ACAD.LEVEL] [varchar](max) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_HRPER] PRIMARY KEY CLUSTERED 
(
	[HRPER.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
