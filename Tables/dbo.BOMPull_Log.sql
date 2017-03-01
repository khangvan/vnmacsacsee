CREATE TABLE [dbo].[BOMPull_Log] (
  [BOMPull_Log_ID] [int] IDENTITY,
  [BOMPull_Log_text] [varchar](512) NULL,
  [BOMPull_Log_DateTime] [datetime] NULL,
  CONSTRAINT [PK_BOMPull_Log] PRIMARY KEY CLUSTERED ([BOMPull_Log_ID])
)
ON [PRIMARY]
GO