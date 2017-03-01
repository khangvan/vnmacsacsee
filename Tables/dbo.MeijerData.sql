CREATE TABLE [dbo].[MeijerData] (
  [Meijer_ID] [int] IDENTITY,
  [Meijer_Customer] [char](20) NULL,
  [Meijer_SalesOrder] [char](20) NULL,
  [Meijer_LineItem] [char](10) NULL,
  [Meijer_Model] [char](30) NULL,
  [Meijer_Description] [char](80) NULL,
  [Meijer_SerialNumber] [char](20) NULL,
  [Meijer_EquipmentRecord] [char](20) NULL,
  [Meijer_WarrantyStart] [datetime] NULL,
  [Meijer_WarrantyEnd] [datetime] NULL,
  [Meijer_Fieldx] [char](20) NULL,
  CONSTRAINT [PK_MeijerData] PRIMARY KEY CLUSTERED ([Meijer_ID])
)
ON [PRIMARY]
GO