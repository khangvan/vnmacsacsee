CREATE TABLE [dbo].[DLM_Actions] (
  [Action_Count] [smallint] NOT NULL,
  [Description] [varchar](50) NULL CONSTRAINT [DF_DLM_Actions_Description] DEFAULT (null),
  [Status] [varchar](50) NULL CONSTRAINT [DF_DLM_Actions_Status] DEFAULT ('A')
)
ON [PRIMARY]
GO