CREATE TABLE [dbo].[NETLocationInfo] (
  [LocationInfo_ID] [int] IDENTITY,
  [ACSEELocation] [char](30) NULL,
  [ACSEEConnectionString] [char](180) NULL,
  [ACSEEClientStateLocation] [char](30) NULL,
  [ACSEEClientStateConnectionString] [char](180) NULL,
  [ACSEEStateLocation] [char](30) NULL,
  [ACSEEStateConnectionString] [char](180) NULL,
  CONSTRAINT [PK_NETLocationInfo] PRIMARY KEY CLUSTERED ([LocationInfo_ID])
)
ON [PRIMARY]
GO