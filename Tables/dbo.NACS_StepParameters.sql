CREATE TABLE [dbo].[NACS_StepParameters] (
  [NACS_StepParameters_id] [int] IDENTITY,
  [NACS_Step_ID] [int] NULL,
  [NACS_StepParameter_Type] [char](20) NULL,
  [NACS_StepParameter_Name] [char](50) NULL,
  [NACS_StepParameter_strValue] [char](80) NULL,
  [NACS_StepParameter_intValue] [int] NULL,
  [NACS_StepParameter_floatValue] [real] NULL,
  [NACS_StepParameter_Description] [char](80) NULL,
  CONSTRAINT [PK_NACS_StepParameters] PRIMARY KEY CLUSTERED ([NACS_StepParameters_id])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[NACS_StepParameters]
  ADD CONSTRAINT [FK_NACS_StepParameters_NACS_TestSteps] FOREIGN KEY ([NACS_Step_ID]) REFERENCES [dbo].[NACS_TestSteps] ([STEP_ID])
GO