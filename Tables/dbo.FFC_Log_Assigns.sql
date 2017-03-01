CREATE TABLE [dbo].[FFC_Log_Assigns] (
  [LOG_ID] [int] IDENTITY,
  [Log_User] [varchar](50) NULL,
  [Log_URL] [varchar](50) NULL,
  [Log_Time] [datetime] NULL,
  [Log_RequestName] [text] NULL,
  [Log_Request] [text] NULL,
  [Log_Response] [text] NULL,
  [Log_ResponseTime] [datetime] NULL,
  [LOG_Status] [char](10) NULL,
  [LOG_Error] [varchar](50) NULL,
  [LOG_Notes] [varchar](50) NULL,
  CONSTRAINT [PK_FFC_Log_Assigns] PRIMARY KEY CLUSTERED ([LOG_ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO