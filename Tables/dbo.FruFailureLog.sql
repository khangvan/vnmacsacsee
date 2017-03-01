CREATE TABLE [dbo].[FruFailureLog] (
  [FLG_FL_ID] [int] IDENTITY,
  [FLG_RepairAction_ID] [int] NULL,
  [FLG_CauseCategory_ID] [int] NULL,
  [FLG_Fru_ID] [int] NULL,
  [FLG_ACSSN_ID] [int] NULL,
  [FLG_TL_ID] [int] NULL,
  [FLG_ACSSN] [char](80) NULL,
  [FLG_Failure] [char](80) NULL,
  [FLG_Station_ID] [int] NULL,
  [FLG_Station] [char](80) NULL,
  [FLG_RootCauseComment] [varchar](80) NULL,
  [FLG_RootCauseOwner] [varchar](80) NULL,
  [FLG_Critical] [tinyint] NULL,
  [FLG_ORT] [char](2) NULL,
  [FLG_Technician] [varchar](80) NULL,
  [FLG_PreventativeAction] [varchar](80) NULL,
  [FLG_Comments] [varchar](80) NULL,
  [FLG_FailureLogDate] [datetime] NULL,
  [FLG_DateGrouping_ID] [int] NULL,
  [FLG_Touched] [tinyint] NULL,
  CONSTRAINT [PK_FruFailureLog] PRIMARY KEY CLUSTERED ([FLG_FL_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[FruFailureLog] WITH NOCHECK
  ADD CONSTRAINT [FK_FruFailureLog_TestLog] FOREIGN KEY ([FLG_TL_ID]) REFERENCES [dbo].[TestLog] ([TL_ID])
GO