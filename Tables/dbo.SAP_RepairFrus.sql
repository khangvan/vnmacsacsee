CREATE TABLE [dbo].[SAP_RepairFrus] (
  [RFU_Fru_ID] [int] IDENTITY,
  [RFU_FruDescription] [char](80) NULL,
  [RFU_cFruCode] [varchar](50) NULL,
  [RFU_FruCode] [int] NULL,
  [RFU_Order] [int] NULL,
  [RFU_Type] [int] NULL,
  [RFU_Station] [int] NULL,
  [RFU_Remark] [varchar](80) NULL,
  CONSTRAINT [PK_SAP_RepairFrus] PRIMARY KEY CLUSTERED ([RFU_Fru_ID])
)
ON [PRIMARY]
GO