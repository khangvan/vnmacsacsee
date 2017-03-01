CREATE TABLE [dbo].[LegacyFruFailureLog] (
  [FLG_FL_ID] [int] IDENTITY,
  [FLG_RepairAction_ID] [int] NULL,
  [FLG_CauseCategory_ID] [int] NULL,
  [FLG_OriginCode_ID] [int] NULL,
  [FLG_Fru_ID] [int] NULL,
  [FLG_ACSSN_ID] [int] NULL,
  [FLG_TL_ID] [int] NULL,
  [FLG_ACSSN] [char](80) NULL,
  [FLG_Model] [char](20) NULL,
  [FLG_Failure] [char](80) NULL,
  [FLG_Station_ID] [int] NULL,
  [FLG_Station] [char](80) NULL,
  [FLG_RootCauseComment] [varchar](80) NULL,
  [FLG_RootCauseOwner] [varchar](80) NULL,
  [FLG_Critical] [tinyint] NULL,
  [FLG_ORT] [char](10) NULL,
  [FLG_Technician] [varchar](80) NULL,
  [FLG_PreventativeAction] [varchar](80) NULL,
  [FLG_Comments] [varchar](80) NULL,
  [FLG_FailureLogDate] [datetime] NULL,
  [FLG_DateGrouping_ID] [int] NULL,
  [FLG_Type] [int] NULL,
  [FLG_Touched] [tinyint] NULL,
  [FLG_ReportType] [int] NULL,
  [FLG_Generated] [tinyint] NULL,
  [FLG_LastModified] [datetime] NULL,
  CONSTRAINT [PK_LegacyFruFailureLog] PRIMARY KEY CLUSTERED ([FLG_FL_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_Serial]
  ON [dbo].[LegacyFruFailureLog] ([FLG_ACSSN])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[LegacyFruFailureLog] WITH NOCHECK
  ADD CONSTRAINT [FK_LegacyFruFailureLog_OriginCodes] FOREIGN KEY ([FLG_OriginCode_ID]) REFERENCES [dbo].[OriginCodes] ([OCD_ID])
GO

ALTER TABLE [dbo].[LegacyFruFailureLog] WITH NOCHECK
  ADD CONSTRAINT [FK_LegacyFruFailureLog_RepairAction] FOREIGN KEY ([FLG_RepairAction_ID]) REFERENCES [dbo].[RepairAction] ([RAN_RepairAction_ID])
GO

ALTER TABLE [dbo].[LegacyFruFailureLog] WITH NOCHECK
  ADD CONSTRAINT [FK_LegacyFruFailureLog_SAP_NewRepairFrus] FOREIGN KEY ([FLG_Fru_ID]) REFERENCES [dbo].[SAP_NewRepairFrus] ([RFU_Fru_ID])
GO