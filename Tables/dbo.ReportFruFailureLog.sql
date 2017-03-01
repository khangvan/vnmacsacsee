CREATE TABLE [dbo].[ReportFruFailureLog] (
  [FLG_FL_ID] [int] NOT NULL,
  [FLG_RepairAction_ID] [int] NULL,
  [FLG_CauseCategory_ID] [int] NULL,
  [FLG_OriginCode_ID] [int] NULL,
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
  [FLG_LastModified] [datetime] NULL
)
ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [IDX_FLG_FL_ID]
  ON [dbo].[ReportFruFailureLog] ([FLG_FL_ID])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO