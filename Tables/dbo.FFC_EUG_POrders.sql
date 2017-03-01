CREATE TABLE [dbo].[FFC_EUG_POrders] (
  [FFC_PO_ID] [int] NOT NULL,
  [FFC_PO] [varchar](50) NULL,
  [FFC_Item] [int] NULL,
  [FFC_BOM] [varchar](50) NULL,
  [FFC_BOM_ID] [int] NULL,
  [FFC_Qty] [int] NULL,
  [FFC_UnitOfMeasure] [char](10) NULL,
  [FFC_PSCSO] [varchar](50) NULL,
  [FFC_PSCItem] [int] NULL,
  [FFC_Name1] [varchar](50) NULL,
  [FFC_Name2] [varchar](50) NULL,
  [FFC_Street1] [varchar](50) NULL,
  [FFC_Street2] [varchar](50) NULL,
  [FFC_City1] [varchar](50) NULL,
  [FFC_City2] [varchar](50) NULL,
  [FFC_Postal1] [varchar](50) NULL,
  [FFC_Postal2] [varchar](50) NULL,
  [FFC_Country] [varchar](50) NULL,
  [FFC_Attn] [varchar](50) NULL,
  [FFC_StatusID] [int] NULL,
  [FFC_QtyBoxed] [int] NULL,
  [FFC_Status] [varchar](50) NULL
)
ON [PRIMARY]
GO