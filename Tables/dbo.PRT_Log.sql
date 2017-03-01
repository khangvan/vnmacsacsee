CREATE TABLE [dbo].[PRT_Log] (
  [LOG_ID] [int] IDENTITY,
  [Log_User] [varchar](100) NULL,
  [Log_Machine] [varchar](100) NULL,
  [Log_Time] [datetime] NULL,
  [Log_Location] [varchar](100) NULL,
  [Log_Message] [varchar](100) NULL,
  [Log_AdjunctMessage] [varchar](100) NULL,
  [LOG_Status] [char](10) NULL,
  [LOG_Notes] [varchar](100) NULL,
  [LOG_DBTime] [datetime] NULL,
  CONSTRAINT [PK_PRT_Log] PRIMARY KEY CLUSTERED ([LOG_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO