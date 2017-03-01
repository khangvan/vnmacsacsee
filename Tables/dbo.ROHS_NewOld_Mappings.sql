CREATE TABLE [dbo].[ROHS_NewOld_Mappings] (
  [ROHSMap_ID] [int] IDENTITY,
  [ROHS_Model] [char](20) NULL,
  [PreROHS_model] [char](20) NULL,
  [DateAdded] [datetime] NULL,
  [LO] [char](10) NULL,
  [MType] [char](10) NULL,
  CONSTRAINT [PK_ROHS_NewOld_Mappings] PRIMARY KEY CLUSTERED ([ROHSMap_ID])
)
ON [PRIMARY]
GO