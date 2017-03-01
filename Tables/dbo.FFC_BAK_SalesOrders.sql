CREATE TABLE [dbo].[FFC_BAK_SalesOrders] (
  [FFC_BAK_Id] [int] NULL,
  [FFC_BAK_SalesOrder] [nchar](20) NULL,
  [FFC_BAK_Model] [nchar](20) NULL,
  [FFC_BAK_Name] [nchar](50) NULL,
  [FFC_BAK_Street] [nchar](50) NULL,
  [FFC_BAK_City] [nchar](50) NULL,
  [FFC_BAK_State] [nchar](10) NULL,
  [FFC_BAK_PostalCode] [nchar](10) NULL,
  [FFC_BAK_IntCode] [nchar](3) NULL,
  [FFC_BAK_OTDDate] [datetime] NULL,
  [FFC_BAK_Qty] [int] NULL,
  [FFC_BAK_QtyBoxed] [int] NULL,
  [FFC_BAK_Vender] [nchar](10) NULL,
  [FFC_BAK_Country] [nchar](10) NULL,
  [FFC_BAK_Hiearchy] [nchar](20) NULL,
  [FFC_BAK_Blockingcode] [nchar](3) NULL,
  [FFC_BAK_CustPart] [nchar](22) NULL,
  [FFC_BAK_Attn] [nchar](35) NULL,
  [FFC_BAK_PO] [nchar](21) NULL
)
ON [PRIMARY]
GO