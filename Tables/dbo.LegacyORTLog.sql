CREATE TABLE [dbo].[LegacyORTLog] (
  [FLG_FL_ID] [int] IDENTITY,
  [FLG_Failed] [tinyint] NULL,
  [FLG_RepairAction_ID] [int] NULL,
  [FLG_CauseCategory_ID] [int] NULL,
  [FLG_OriginCode_ID] [int] NULL,
  [FLG_Fru_ID] [int] NULL,
  [FLG_ACSSN_ID] [int] NULL,
  [FLG_ACSSN] [char](20) NULL,
  [FLG_MappedACSSN_ID] [int] NULL,
  [FLG_Model] [char](20) NULL,
  [FLG_Model_ID] [int] NULL,
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
  [FLG_EnterORT] [datetime] NULL,
  [FLG_ExitORT] [datetime] NULL,
  CONSTRAINT [PK_LegacyORTLog] PRIMARY KEY CLUSTERED ([FLG_FL_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[LegacyORTLog] WITH NOCHECK
  ADD CONSTRAINT [FK_LegacyORTLog_LegacyORTMap] FOREIGN KEY ([FLG_MappedACSSN_ID]) REFERENCES [dbo].[LegacyORTMap] ([LOM_ID])
GO