CREATE TABLE [dbo].[NACS_TestSteps] (
  [STEP_ID] [int] NOT NULL,
  [STEP_Station] [varchar](20) NULL,
  [STEP_Model] [varchar](20) NULL,
  [STEP_StepName] [varchar](20) NULL,
  [STEP_StepType] [varchar](10) NULL,
  [STEP_StepNotes] [varchar](20) NULL,
  [STEP_Author] [varchar](50) NULL,
  [STEP_TestType] [varchar](10) NULL,
  [STEP_GroupID] [int] NULL,
  CONSTRAINT [PK_NACS_TestSteps] PRIMARY KEY CLUSTERED ([STEP_ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[NACS_TestSteps]
  ADD CONSTRAINT [FK_NACS_TestSteps_NACS_StepGroups] FOREIGN KEY ([STEP_GroupID]) REFERENCES [dbo].[NACS_StepGroups] ([STPGRP_ID])
GO