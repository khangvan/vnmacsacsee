CREATE TABLE [dbo].[WIPAvailableSalesOrders] (
  [WIPASO_ID] [int] NOT NULL,
  [WIPASO_SalesOrders] [char](30) NULL,
  [WIPASO_SAPModel] [char](30) NULL,
  [WIPASO_Name] [char](80) NULL,
  [WIPASO_Street] [char](50) NULL,
  [WIPASO_City] [char](50) NULL,
  [WIPSAO_State] [char](50) NULL,
  [WIPASO_PostalCode] [char](20) NULL,
  [WIPASO_IntCode] [char](50) NULL,
  [WIPASO_OTDDate] [datetime] NULL,
  [WIPASO_Quantity] [int] NULL,
  [WIPASO_QtyBoxed] [int] NULL,
  [WIPASO_Vendor] [char](80) NULL,
  [WIPASO_Country] [char](80) NULL,
  [WIPASO_Hierarchy] [char](20) NULL,
  [WIPASO_BlockingCode] [char](50) NULL,
  [WIPASO_CustPart] [char](80) NULL,
  [WIPASO_Attn] [char](50) NULL,
  [WIPASO_PO] [char](50) NULL
)
ON [PRIMARY]
GO