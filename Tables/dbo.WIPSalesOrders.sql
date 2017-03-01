CREATE TABLE [dbo].[WIPSalesOrders] (
  [WIPSO_ID] [int] NOT NULL,
  [WIPSO_SalesOrders] [char](30) NULL,
  [WIPSO_SAPModel] [char](30) NULL,
  [WIPSO_Name] [char](80) NULL,
  [WIPSO_Street] [char](50) NULL,
  [WIPSO_City] [char](50) NULL,
  [WIPSO_State] [char](50) NULL,
  [WIPSO_PostalCode] [char](20) NULL,
  [WIPSO_IntCode] [char](50) NULL,
  [WIPSO_OTDDate] [datetime] NULL,
  [WIPSO_Quantity] [int] NULL,
  [WIPSO_QtyBoxed] [int] NULL,
  [WIPSO_Vendor] [char](80) NULL,
  [WIPSO_Country] [char](80) NULL,
  [WIPSO_Hierarchy] [char](20) NULL,
  [WIPSO_BlockingCode] [char](50) NULL,
  [WIPSO_CustPart] [char](80) NULL,
  [WIPSO_Attn] [char](50) NULL,
  [WIPSO_PO] [char](50) NULL
)
ON [PRIMARY]
GO