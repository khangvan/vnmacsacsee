CREATE TABLE [dbo].[TM_TLID_mapping] (
  [PTD_ID] [int] IDENTITY,
  [TM_ID] [int] NULL,
  [DB1_ID] [int] NULL,
  [Transfer_Time] [datetime] NULL,
  CONSTRAINT [PK_TM_TLID_mapping] PRIMARY KEY CLUSTERED ([PTD_ID])
)
ON [PRIMARY]
GO