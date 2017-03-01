CREATE TABLE [dbo].[FFC_SerialNumbers] (
  [FFC_Serial_ID] [int] IDENTITY,
  [FFC_SerialNumber] [varchar](50) NULL,
  [FFC_PO_ID] [int] NULL,
  [FFC_Status_ID] [int] NULL,
  CONSTRAINT [PK_FFC_SerialNumbers] PRIMARY KEY CLUSTERED ([FFC_Serial_ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[FFC_SerialNumbers] WITH NOCHECK
  ADD CONSTRAINT [FK_FFC_SerialNumbers_FFC_POrders] FOREIGN KEY ([FFC_PO_ID]) REFERENCES [dbo].[FFC_POrders] ([FFC_PO_ID])
GO