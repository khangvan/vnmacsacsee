CREATE TABLE [dbo].[BCSBACKUP_BCS_StepParameters] (
  [NACS_StepParameters_id] [int] NOT NULL,
  [NACS_Step_ID] [int] NULL,
  [NACS_StepParameter_Type] [char](120) NULL,
  [NACS_StepParameter_Name] [char](150) NULL,
  [NACS_StepParameter_strValue] [char](180) NULL,
  [NACS_StepParameter_intValue] [int] NULL,
  [NACS_StepParameter_floatValue] [real] NULL,
  [NACS_StepParameter_Description] [char](180) NULL,
  [NACS_StepParameter_Object] [varchar](3000) NULL
)
ON [PRIMARY]
GO