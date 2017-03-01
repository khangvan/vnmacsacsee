CREATE TABLE [dbo].[Actions] (
  [Action_Count] [smallint] NOT NULL,
  [Description] [varchar](50) NULL CONSTRAINT [DF_Actions_Description] DEFAULT (null),
  [Status] [varchar](50) NULL CONSTRAINT [DF_Actions_Status] DEFAULT ('A'),
  CONSTRAINT [PK_Actions] PRIMARY KEY NONCLUSTERED ([Action_Count]) WITH (FILLFACTOR = 90)
)
ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [IDX_Action_Count]
  ON [dbo].[Actions] ([Action_Count])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO