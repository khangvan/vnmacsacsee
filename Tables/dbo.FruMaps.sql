CREATE TABLE [dbo].[FruMaps] (
  [FMP_ID] [int] IDENTITY,
  [FMP_ReportGroup] [int] NULL,
  [FMP_Fru_ID] [int] NULL,
  CONSTRAINT [PK_FruMaps] PRIMARY KEY CLUSTERED ([FMP_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[FruMaps] WITH NOCHECK
  ADD CONSTRAINT [FK_FruMaps_SAP_NewRepairFrus] FOREIGN KEY ([FMP_Fru_ID]) REFERENCES [dbo].[SAP_NewRepairFrus] ([RFU_Fru_ID])
GO