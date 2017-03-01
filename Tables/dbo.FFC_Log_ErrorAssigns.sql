CREATE TABLE [dbo].[FFC_Log_ErrorAssigns] (
  [LOG_ID] [int] IDENTITY,
  [Log_User] [varchar](200) NULL,
  [Log_URL] [varchar](200) NULL,
  [Log_Time] [datetime] NULL,
  [Log_RequestName] [text] NULL,
  [Log_Request] [text] NULL,
  [Log_Response] [text] NULL,
  [Log_ResponseTime] [datetime] NULL,
  [LOG_Status] [char](10) NULL,
  [LOG_Error] [varchar](100) NULL,
  [LOG_Notes] [varchar](100) NULL,
  CONSTRAINT [PK_FFC_Log_ErrorAssigns] PRIMARY KEY CLUSTERED ([LOG_ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO