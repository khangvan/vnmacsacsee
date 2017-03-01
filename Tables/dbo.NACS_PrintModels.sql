CREATE TABLE [dbo].[NACS_PrintModels] (
  [NACS_PrintModel_ID] [int] IDENTITY,
  [NACS_PrintModel_Name] [varchar](50) NULL,
  CONSTRAINT [PK_NACS_PrintModels] PRIMARY KEY CLUSTERED ([NACS_PrintModel_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO