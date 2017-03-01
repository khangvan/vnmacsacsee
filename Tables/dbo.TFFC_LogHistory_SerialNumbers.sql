CREATE TABLE [dbo].[TFFC_LogHistory_SerialNumbers] (
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
  [TFFC_LogDate] [datetime] NULL,
  [TFFC_Reason1] [char](80) NULL,
  [TFFC_Reason2] [char](80) NULL,
  CONSTRAINT [PK_TFFC_LogHistory_SerialNumbers] PRIMARY KEY CLUSTERED ([TFFC_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO