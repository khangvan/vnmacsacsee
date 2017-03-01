CREATE TABLE [dbo].[NACS_StepLimitMapping] (
  [NACS_StepLimitMapping_ID] [int] IDENTITY,
  [NACS_StepLimitMapping_Subtest_ID] [int] NULL,
  [NACS_StepLimitMapping_Step_ID] [int] NULL,
  CONSTRAINT [PK_NACS_StepLimitMapping] PRIMARY KEY CLUSTERED ([NACS_StepLimitMapping_ID])
)
ON [PRIMARY]
GO