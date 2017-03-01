CREATE TABLE [dbo].[TFFC_ReserveLog] (
  [LOG_ID] [int] IDENTITY,
  [LOGTime] [datetime] NULL,
  [LogRecord] [varchar](512) NULL,
  [ACSSerial] [char](30) NULL,
  [SAPSerial] [char](20) NULL,
  [ReturnedSerial] [char](20) NULL,
  CONSTRAINT [PK_TFFC_ReserveLog] PRIMARY KEY CLUSTERED ([LOG_ID])
)
ON [PRIMARY]
GO