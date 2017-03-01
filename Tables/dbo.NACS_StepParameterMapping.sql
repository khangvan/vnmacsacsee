CREATE TABLE [dbo].[NACS_StepParameterMapping] (
  [NACS_StepParameterMapping_id] [int] IDENTITY,
  [NACS_StepParameterMapping_step_id] [int] NULL,
  [NACS_StepParameterMapping_Parameter_id] [int] NULL,
  [NACS_StepParameterMapping_Description] [varchar](80) NULL,
  CONSTRAINT [PK_NACS_StepParameterMapping] PRIMARY KEY CLUSTERED ([NACS_StepParameterMapping_id])
)
ON [PRIMARY]
GO