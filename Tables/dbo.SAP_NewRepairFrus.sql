CREATE TABLE [dbo].[SAP_NewRepairFrus] (
  [RFU_Fru_ID] [int] NOT NULL,
  [RFU_FruDescription] [char](80) NULL,
  [RFU_cFruCode] [nvarchar](50) NULL,
  [RFU_FruCode] [int] NULL,
  [RFU_Order] [int] NULL,
  [RFU_Type] [int] NULL,
  [RFU_Station] [int] NULL,
  [RFU_Remark] [varchar](80) NULL,
  [RFU_ProductLine] [char](20) NULL,
  CONSTRAINT [PK_SAP_NewRepairFrus] PRIMARY KEY CLUSTERED ([RFU_Fru_ID])
)
ON [PRIMARY]
GO