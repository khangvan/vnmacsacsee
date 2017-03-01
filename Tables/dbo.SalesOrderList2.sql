CREATE TABLE [dbo].[SalesOrderList2] (
  [SO_ID] [int] IDENTITY,
  [SO_SoldTo] [char](80) NULL,
  [SO_InvoiceDate] [datetime] NULL,
  [SO_Material] [char](20) NULL,
  [SO_Number] [char](10) NULL,
  [SO_Item] [int] NULL,
  [SO_Qty] [int] NULL,
  CONSTRAINT [PK_SalesOrderList2] PRIMARY KEY CLUSTERED ([SO_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO