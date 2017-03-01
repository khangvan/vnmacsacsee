CREATE TABLE [dbo].[Travellers] (
  [ACS_Serial] [char](20) NOT NULL,
  [Part_No] [int] NOT NULL,
  [Rev] [char](2) NULL CONSTRAINT [DF_Travellers_Rev] DEFAULT (null),
  [Quantity_Required] [int] NOT NULL CONSTRAINT [DF_Travellers_Quantity_Required] DEFAULT ('1'),
  [Quantity_Filled] [int] NOT NULL CONSTRAINT [DF_Travellers_Qutitiy_Filled] DEFAULT ('0'),
  [T_ID] [int] IDENTITY,
  [msrepl_synctran_ts] [timestamp],
  CONSTRAINT [PK_Travellers] PRIMARY KEY NONCLUSTERED ([T_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Travellers] WITH NOCHECK
  ADD CONSTRAINT [FK_Travellers_Catalog] FOREIGN KEY ([Part_No]) REFERENCES [dbo].[Catalog] ([Part_No_Count])
GO