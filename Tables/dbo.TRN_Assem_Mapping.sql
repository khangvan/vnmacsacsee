CREATE TABLE [dbo].[TRN_Assem_Mapping] (
  [PTD_ID] [int] NOT NULL,
  [TRNAssem_ID] [int] NULL,
  [DB1Assem_ID] [int] NULL,
  [Transfer_Time] [datetime] NULL,
  CONSTRAINT [PK_TRN_Assem_Mapping] PRIMARY KEY CLUSTERED ([PTD_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO