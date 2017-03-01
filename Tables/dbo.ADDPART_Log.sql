CREATE TABLE [dbo].[ADDPART_Log] (
  [ADDPARTLOG_ID] [int] IDENTITY,
  [ADDPARTLOG_Action] [varchar](50) NULL,
  [ADDPARTLOG_TOPSerial] [char](20) NULL,
  [ADDPARTLOG_BottomSerial] [char](20) NULL,
  [ADDPARTLOG_Part] [char](20) NULL,
  [ADDPARTLOG_Note] [varchar](50) NULL,
  [ADDPARTLOG_DateTime] [datetime] NULL,
  CONSTRAINT [PK_ADDPART_Log] PRIMARY KEY CLUSTERED ([ADDPARTLOG_ID])
)
ON [PRIMARY]
GO