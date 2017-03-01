CREATE TABLE [dbo].[Lines] (
  [Station] [int] NOT NULL,
  [Next_Station] [int] NOT NULL,
  [FactoryGroup_Mask] [int] NULL,
  [ProductGroup_Mask] [int] NULL,
  CONSTRAINT [PK_Lines] PRIMARY KEY NONCLUSTERED ([Station], [Next_Station]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

CREATE INDEX [IX_Lines_Station_Name]
  ON [dbo].[Lines] ([Station])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[Lines] WITH NOCHECK
  ADD CONSTRAINT [FK_Lines_Stations] FOREIGN KEY ([Station]) REFERENCES [dbo].[Stations] ([Station_Count])
GO

ALTER TABLE [dbo].[Lines] WITH NOCHECK
  ADD CONSTRAINT [FK_Lines_Stations2] FOREIGN KEY ([Next_Station]) REFERENCES [dbo].[Stations] ([Station_Count])
GO