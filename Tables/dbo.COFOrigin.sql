CREATE TABLE [dbo].[COFOrigin] (
  [COF_ID] [int] IDENTITY,
  [COF_PSC_ScannedSerial] [char](10) NULL,
  [COF_PSC_ScannedModel] [char](30) NULL,
  [COF_ACS_ScannedSerial] [char](10) NULL,
  [COF_PartNumber] [char](10) NULL,
  [COF_Country] [char](50) NULL,
  [COF_ShortCountry] [char](2) NULL,
  CONSTRAINT [PK_COFOrigin] PRIMARY KEY CLUSTERED ([COF_ID])
)
ON [PRIMARY]
GO