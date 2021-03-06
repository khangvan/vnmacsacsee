﻿CREATE TABLE [dbo].[OneSapCatalog_Tracker] (
  [OneSapCatalog_ID] [int] IDENTITY,
  [OneSapCatalog_part_no] [int] NULL,
  [OneSapCatalog_PartName] [char](30) NULL,
  [OneSapCatalog_OldPartName] [char](30) NULL,
  [OneSapCatalog_OldPartDescription] [char](120) NULL,
  [OneSapCatalog_NewPartDescription] [char](120) NULL,
  [OneSapCatalog_AddDate] [datetime] NULL,
  CONSTRAINT [PK_OneSapCatalog_Tracker] PRIMARY KEY CLUSTERED ([OneSapCatalog_ID])
)
ON [PRIMARY]
GO