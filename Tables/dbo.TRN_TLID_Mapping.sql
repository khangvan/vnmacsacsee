CREATE TABLE [dbo].[TRN_TLID_Mapping] (
  [PTD_ID] [int] IDENTITY,
  [TRN_ID] [int] NULL,
  [DB1_ID] [int] NULL,
  [Transfer_Time] [datetime] NULL,
  CONSTRAINT [PK_TRN_TLID_Mapping] PRIMARY KEY CLUSTERED ([PTD_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO