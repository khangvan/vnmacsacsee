CREATE TABLE [dbo].[FFC_SendbackInfo] (
  [FFC_Sendback_ID] [int] IDENTITY,
  [FFC_PO_ID] [int] NULL,
  [FFC_Item] [int] NULL,
  [FFC_PSCSO] [varchar](50) NULL,
  [FFC_Serialnumber] [varchar](50) NULL,
  [FFC_SerialNumber_ID] [int] NULL,
  [FF_Status_ID] [int] NULL,
  CONSTRAINT [PK_FFC_SendbackInfo] PRIMARY KEY CLUSTERED ([FFC_Sendback_ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[FFC_SendbackInfo] WITH NOCHECK
  ADD CONSTRAINT [FK_FFC_SendbackInfo_FFC_POrders] FOREIGN KEY ([FFC_PO_ID]) REFERENCES [dbo].[FFC_POrders] ([FFC_PO_ID])
GO