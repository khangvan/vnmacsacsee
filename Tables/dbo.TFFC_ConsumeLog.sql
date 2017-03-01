CREATE TABLE [dbo].[TFFC_ConsumeLog] (
  [LOG_ID] [int] IDENTITY,
  [LogTime] [datetime] NULL,
  [LogRecord] [varchar](300) NULL,
  [ACSSerial] [char](30) NULL,
  [SAPSerial] [char](20) NULL,
  [ReservedSerial] [char](20) NULL,
  CONSTRAINT [PK_TFFC_ConsumeLog] PRIMARY KEY CLUSTERED ([LOG_ID])
)
ON [PRIMARY]
GO