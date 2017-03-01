CREATE TABLE [dbo].[FFC_EUGPAN_MAPPING] (
  [EUGPANMAP_ID] [int] IDENTITY,
  [EUGENE_StationName] [varchar](50) NULL,
  [EUGENE_Station_Count] [int] NULL,
  [PAN_StationName] [varchar](50) NULL,
  [PAN_StationType] [int] NULL,
  [PAN_Station_Count] [int] NULL,
  [Vendor_ID] [char](10) NULL,
  CONSTRAINT [PK_FFC_EUGPAN_MAPPING] PRIMARY KEY CLUSTERED ([EUGPANMAP_ID])
)
ON [PRIMARY]
GO