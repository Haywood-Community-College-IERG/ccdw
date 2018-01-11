USE [IERG]
GO
/****** Object:  Table [history].[TA_ACYR]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[TA_ACYR](
	[TA.STUDENT.ID] [varchar](20) NOT NULL,
	[TA.ACYR] [varchar](max) NULL,
	[TA.FIRST] [varchar](16) NULL,
	[TA.MIDDLE] [varchar](16) NULL,
	[TA.LAST] [varchar](16) NULL,
	[TA.AWDP.START.DATE] [date] NULL,
	[TA.TERM] [varchar](20) NOT NULL,
	[TA.REG.CREDITS] [numeric](10, 2) NULL,
	[TA.QUERY.REG.CREDITS] [numeric](10, 2) NULL,
	[TA.NEED] [numeric](7, 0) NULL,
	[TA.INST.NEED] [numeric](7, 0) NULL,
	[TA.AW.ID] [varchar](20) NOT NULL,
	[TA.AWARD.CATEGORY] [varchar](5) NULL,
	[TA.TERM.ACTION] [varchar](10) NULL,
	[TA.TERM.AMOUNT] [numeric](8, 2) NULL,
	[TA.AMT.FLAG] [varchar](1) NULL,
	[TA.TERM.XMIT.AMT] [numeric](8, 2) NULL,
	[TA.TERM.XMIT.DT] [date] NULL,
	[TA.XMIT.FLAG] [varchar](3) NULL,
	[TA.TERM.UNXMIT.AMT] [numeric](8, 2) NULL,
	[TA.D7.EXCESS.XMIT.AMT] [numeric](8, 2) NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_TA_ACYR] PRIMARY KEY CLUSTERED 
(
	[TA.STUDENT.ID] ASC,
	[TA.AW.ID] ASC,
	[TA.TERM] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
