CREATE TABLE [dbo].[FFC_COFOrigin] (
  [COF_ID] [int] NOT NULL,
  [COF_PSC_ScannedSerial] [char](10) NULL,
  [COF_PSC_ScannedModel] [char](10) NULL,
  [COF_ACS_ScannedSerial] [char](10) NULL,
  [COF_PartNumber] [char](10) NULL,
  [COF_Country] [char](50) NULL,
  [COF_ShortCountry] [char](2) NULL
)
ON [PRIMARY]
GO