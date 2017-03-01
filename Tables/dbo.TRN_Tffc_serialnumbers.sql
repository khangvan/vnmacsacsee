CREATE TABLE [dbo].[TRN_Tffc_serialnumbers] (
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
  CONSTRAINT [PK_TRN_Tffc_serialnumbers] PRIMARY KEY CLUSTERED ([TFFC_ID])
)
ON [PRIMARY]
GO