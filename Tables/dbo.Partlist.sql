CREATE TABLE [dbo].[Partlist] (
  [Part_No] [int] NOT NULL,
  [Station] [int] NOT NULL,
  [Menu] [char](1) NULL CONSTRAINT [DF_Partlist_Menu_Name] DEFAULT (null),
  [Automatic] [char](1) NULL CONSTRAINT [DF_Partlist_Automatic] DEFAULT (null),
  [Get_Serial] [char](5) NULL CONSTRAINT [DF_Partlist_Get_Serial] DEFAULT (null),
  [Disp_Order] [int] NOT NULL CONSTRAINT [DF_Partlist_Disp_Order] DEFAULT ('1'),
  [Fill_Quantity] [int] NOT NULL CONSTRAINT [DF_Partlist_Fill_Quantity] DEFAULT ('1'),
  [PL_ID] [int] IDENTITY,
  CONSTRAINT [PK_Partlist] PRIMARY KEY CLUSTERED ([PL_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

CREATE INDEX [IX_Partlist_Station_Name]
  ON [dbo].[Partlist] ([Station])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[Partlist] WITH NOCHECK
  ADD CONSTRAINT [FK_Partlist_Catalog] FOREIGN KEY ([Part_No]) REFERENCES [dbo].[Catalog] ([Part_No_Count])
GO