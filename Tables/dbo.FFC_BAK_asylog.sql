CREATE TABLE [dbo].[FFC_BAK_asylog] (
  [ACS_Serial] [char](20) NOT NULL,
  [Station] [int] NOT NULL,
  [Action] [smallint] NOT NULL,
  [Added_Part_No] [int] NULL CONSTRAINT [DF_FFC_BAK_asylog_Added_Part_No] DEFAULT (null),
  [Scanned_Serial] [char](20) NULL CONSTRAINT [DF_FFC_BAK_asylog_Scanned_Serial] DEFAULT (null),
  [Rev] [char](2) NULL CONSTRAINT [DF_FFC_BAK_asylog_Rev] DEFAULT (null),
  [Action_Date] [datetime] NOT NULL,
  [Quantity] [int] NULL CONSTRAINT [DF_FFC_BAK_asylog_Quantity] DEFAULT (null),
  [asylog_ID] [int] NOT NULL
)
ON [PRIMARY]
GO