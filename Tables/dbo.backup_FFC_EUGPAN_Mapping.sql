CREATE TABLE [dbo].[backup_FFC_EUGPAN_Mapping] (
  [EUGPANMAP_ID] [int] NOT NULL,
  [EUGENE_StationName] [varchar](50) NULL,
  [EUGENE_Station_Count] [int] NULL,
  [PAN_StationName] [varchar](50) NULL,
  [PAN_StationType] [int] NULL,
  [PAN_Station_Count] [int] NULL,
  [Vendor_ID] [char](10) NULL
)
ON [PRIMARY]
GO