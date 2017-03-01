CREATE TABLE [dbo].[BCS_StepParameters] (
  [NACS_StepParameters_id] [int] IDENTITY,
  [NACS_Step_ID] [int] NULL,
  [NACS_StepParameter_Type] [char](120) NULL,
  [NACS_StepParameter_Name] [char](150) NULL,
  [NACS_StepParameter_strValue] [char](180) NULL,
  [NACS_StepParameter_intValue] [int] NULL,
  [NACS_StepParameter_floatValue] [real] NULL,
  [NACS_StepParameter_Description] [char](180) NULL,
  [NACS_StepParameter_Object] [varchar](3000) NULL,
  CONSTRAINT [PK_BCS_StepParameters] PRIMARY KEY CLUSTERED ([NACS_StepParameters_id])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[BCS_StepParameters]
  ADD CONSTRAINT [FK_BCS_StepParameters_BCS_Step] FOREIGN KEY ([NACS_Step_ID]) REFERENCES [dbo].[BCS_Steps] ([STEP_ID]) ON DELETE CASCADE
GO