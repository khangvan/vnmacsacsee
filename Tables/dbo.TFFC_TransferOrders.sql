CREATE TABLE [dbo].[TFFC_TransferOrders] (
  [TransferOrder_ID] [int] IDENTITY,
  [TransferOrder_WHSE] [char](10) NULL,
  [TransferOrder_OrderNum] [char](10) NULL,
  [TransferOrder_Material] [char](20) NULL,
  [TransferOrder_Description] [char](50) NULL,
  [TransferOrder_WERKS] [char](10) NULL,
  [TransferOrder_Qty] [int] NULL,
  [TransferOrder_Units] [char](10) NULL,
  [TransferOrder_CurrentCount] [int] NULL,
  CONSTRAINT [PK_TFFC_TransferOrders] PRIMARY KEY CLUSTERED ([TransferOrder_ID])
)
ON [PRIMARY]
GO