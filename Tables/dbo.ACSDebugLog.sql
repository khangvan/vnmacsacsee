CREATE TABLE [dbo].[ACSDebugLog] (
  [Station] [char](20) NULL,
  [Log_date] [datetime] NOT NULL,
  [ACS_Serial] [char](20) NULL,
  [PSC_Serial] [char](20) NULL,
  [SAP_Model] [char](20) NULL,
  [Next_Station] [char](20) NULL,
  [Product_Name] [char](20) NULL,
  [Shortie] [char](20) NULL,
  [ProxyClass] [char](20) NOT NULL,
  [ProxyFunction] [char](30) NOT NULL,
  [intValue] [int] NULL,
  [strValue] [char](30) NULL,
  [Comment] [varchar](80) NULL,
  [ACSLog_ID] [int] IDENTITY
)
ON [PRIMARY]
GO

CREATE INDEX [acsindex]
  ON [dbo].[ACSDebugLog] ([ACS_Serial])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [dateindex]
  ON [dbo].[ACSDebugLog] ([Log_date])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [main index]
  ON [dbo].[ACSDebugLog] ([ACSLog_ID])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [Stationindex]
  ON [dbo].[ACSDebugLog] ([Station])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO