CREATE TABLE [dbo].[SalesOrderList] (
  [SO_ID] [int] IDENTITY,
  [SO_Material] [char](20) NULL,
  [SO_Number] [char](10) NULL,
  [SO_Item] [int] NULL,
  [SO_Qty] [int] NULL,
  CONSTRAINT [PK_SalesOrderList] PRIMARY KEY CLUSTERED ([SO_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO