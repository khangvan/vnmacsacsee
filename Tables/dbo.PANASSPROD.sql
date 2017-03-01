﻿CREATE TABLE [dbo].[PANASSPROD] (
  [PANASS_ID] [int] IDENTITY,
  [ACSSerial] [char](20) NULL,
  [SAP_Count] [int] NULL,
  [Station_Count] [int] NULL,
  CONSTRAINT [PK_PANASSPROD] PRIMARY KEY CLUSTERED ([PANASS_ID])
)
ON [PRIMARY]
GO