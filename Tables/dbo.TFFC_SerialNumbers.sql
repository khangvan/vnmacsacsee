CREATE TABLE [dbo].[TFFC_SerialNumbers] (
  [TFFC_ID] [int] IDENTITY,
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
  [TFFC_IsTransferOrder] [int] NULL,
  [TFFC_LabelPrinted] [int] NULL,
  [TFFC_TravellerPrintedWith] [char](20) NULL,
  CONSTRAINT [PK_TFFC_SerialNumbers] PRIMARY KEY CLUSTERED ([TFFC_ID]) WITH (FILLFACTOR = 70)
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_TFFC_Reservedby]
  ON [dbo].[TFFC_SerialNumbers] ([TFFC_Reservedby])
  WITH (FILLFACTOR = 70)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_TFFC_SerialNumber]
  ON [dbo].[TFFC_SerialNumbers] ([TFFC_SerialNumber])
  WITH (FILLFACTOR = 70)
  ON [PRIMARY]
GO

CREATE INDEX [INX_PrdOrd_RsvBy_RDX]
  ON [dbo].[TFFC_SerialNumbers] ([TFFC_ProdOrder], [TFFC_Reservedby])
  WITH (FILLFACTOR = 70)
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[TFFC_SerialNumbers] WITH NOCHECK
  ADD CONSTRAINT [FK_TFFC_SerialNumbers_BOXNUMBER] FOREIGN KEY ([BoxNumberInt]) REFERENCES [dbo].[BOXNUMBER] ([BOXNUMBER_ID]) NOT FOR REPLICATION
GO

ALTER TABLE [dbo].[TFFC_SerialNumbers]
  NOCHECK CONSTRAINT [FK_TFFC_SerialNumbers_BOXNUMBER]
GO