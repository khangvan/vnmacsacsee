CREATE TABLE [dbo].[asylog] (
  [ACS_Serial] [char](20) NOT NULL,
  [Station] [int] NOT NULL,
  [Action] [smallint] NOT NULL,
  [Added_Part_No] [int] NULL CONSTRAINT [DF_asylog_Added_Part_No] DEFAULT (null),
  [Scanned_Serial] [char](20) NULL CONSTRAINT [DF_asylog_Scanned_Serial] DEFAULT (null),
  [Rev] [char](2) NULL CONSTRAINT [DF_asylog_Rev] DEFAULT (null),
  [Action_Date] [datetime] NOT NULL,
  [Quantity] [int] NULL CONSTRAINT [DF_asylog_Quantity] DEFAULT (null),
  [asylog_ID] [int] IDENTITY (4468903, 1),
  CONSTRAINT [PK_asylog] PRIMARY KEY NONCLUSTERED ([asylog_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

CREATE UNIQUE CLUSTERED INDEX [asylog_id]
  ON [dbo].[asylog] ([asylog_ID])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Action_Date]
  ON [dbo].[asylog] ([Action_Date])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Added_Part_No]
  ON [dbo].[asylog] ([Added_Part_No])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Scanned_Serial]
  ON [dbo].[asylog] ([Scanned_Serial])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IX_asylog_ACS_Serial]
  ON [dbo].[asylog] ([ACS_Serial])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[asylog] WITH NOCHECK
  ADD CONSTRAINT [FK_asylog_Actions] FOREIGN KEY ([Action]) REFERENCES [dbo].[Actions] ([Action_Count])
GO

ALTER TABLE [dbo].[asylog]
  NOCHECK CONSTRAINT [FK_asylog_Actions]
GO

ALTER TABLE [dbo].[asylog] WITH NOCHECK
  ADD CONSTRAINT [FK_asylog_Catalog] FOREIGN KEY ([Added_Part_No]) REFERENCES [dbo].[Catalog] ([Part_No_Count])
GO

ALTER TABLE [dbo].[asylog]
  NOCHECK CONSTRAINT [FK_asylog_Catalog]
GO

ALTER TABLE [dbo].[asylog] WITH NOCHECK
  ADD CONSTRAINT [FK_asylog_Stations] FOREIGN KEY ([Station]) REFERENCES [dbo].[Stations] ([Station_Count])
GO

ALTER TABLE [dbo].[asylog]
  NOCHECK CONSTRAINT [FK_asylog_Stations]
GO