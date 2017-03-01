CREATE TABLE [dbo].[ProductLines] (
  [Top_Model_Prfx] [char](5) NOT NULL,
  [PSC_Serial_ID] [char](2) NOT NULL,
  [Product_Name] [char](10) NOT NULL,
  [Last_PSC_Serial_Seq] [int] NULL CONSTRAINT [DF_ProductLines_Last_PSC_Serial_Seq] DEFAULT (null),
  [PSCGen_Station] [int] NOT NULL,
  [Status] [char](1) NOT NULL CONSTRAINT [DF_ProductLines_Status] DEFAULT ('A'),
  [FactoryGroup_Mask] [int] NULL,
  [ProductGroup_Mask] [int] NULL,
  CONSTRAINT [PK_ProductLines] PRIMARY KEY NONCLUSTERED ([Top_Model_Prfx]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

CREATE INDEX [IX_ProductLines_PSC_Serial_ID]
  ON [dbo].[ProductLines] ([PSC_Serial_ID])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductLines] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductLines_Stations] FOREIGN KEY ([PSCGen_Station]) REFERENCES [dbo].[Stations] ([Station_Count])
GO