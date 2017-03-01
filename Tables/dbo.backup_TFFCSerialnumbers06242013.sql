CREATE TABLE [dbo].[backup_TFFCSerialnumbers06242013] (
  [TFFC_ID] [int] NOT NULL,
  [TFFC_ProdOrder] [nchar](20) NULL,
  [TFFC_SerialNumber] [nchar](20) NULL,
  [TFFC_RefreshDate] [datetime] NULL,
  [TFFC_Reserved] [int] NULL,
  [TFFC_Reservedby] [char](20) NULL,
  [TFFC_Consumed] [int] NULL,
  [TFFC_ConsumedDate] [datetime] NULL,
  [TFFC_Material] [char](20) NULL,
  [TFFC_Description] [char](50) NULL,
  [TFFC_ACSSErial] [char](20) NULL,
  [TFFC_StationConsumedAt] [char](20) NULL,
  [TFFC_Period] [char](20) NULL,
  [TFFC_ReservedTime] [datetime] NULL,
  [TFFC_PrintOnDemand] [char](2) NULL,
  [TFFC_PrintOnDemandStation] [char](30) NULL,
  [TFFC_PrePrintScanStation] [char](30) NULL,
  [CTNumber] [char](20) NULL,
  [BoxNumberChar] [char](20) NULL,
  [BoxNumberInt] [int] NULL,
  [TFFC_WasAudited] [int] NULL,
  [TFFC_IsTransferOrder] [int] NULL
)
ON [PRIMARY]
GO