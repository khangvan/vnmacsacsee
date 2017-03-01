CREATE TABLE [dbo].[ACSServerLocations] (
  [ACS_Location_ID] [int] IDENTITY,
  [ACS_Location_Name] [char](20) NULL,
  [ACS_Location_DB] [char](40) NULL,
  [ACS_Location_ConnectStr] [char](80) NULL,
  [ACS_Location_SAPLocation] [char](10) NULL,
  CONSTRAINT [PK_ACSServerLocations] PRIMARY KEY CLUSTERED ([ACS_Location_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO