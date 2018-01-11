USE [IERG]
GO
/****** Object:  Table [history].[TERMS]    Script Date: 1/11/2018 9:56:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [history].[TERMS](
	[TERMS.ID] [varchar](7) NOT NULL,
	[TERM.DESC] [varchar](500) NULL,
	[TERM.START.DATE] [date] NULL,
	[TERM.CENSUS.DATES] [date] NULL,
	[TERM.END.DATE] [date] NULL,
	[TERM.REPORTING.YEAR] [numeric](4, 0) NULL,
	[TERM.COMMENCEMENT.DATE] [date] NULL,
	[TERM.DROP.START.DATE] [date] NULL,
	[TERM.DROP.END.DATE] [date] NULL,
	[TERM.REG.START.DATE] [date] NULL,
	[TERM.REG.END.DATE] [date] NULL,
	[EffectiveDatetime] [datetime] NOT NULL,
	[ExpirationDatetime] [datetime] NULL,
	[CurrentFlag] [varchar](1) NULL,
 CONSTRAINT [pk_TERMS] PRIMARY KEY CLUSTERED 
(
	[TERMS.ID] ASC,
	[EffectiveDatetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
