CREATE TYPE [dbo].[StepParametersRecords] AS TABLE (
  [StepParameter_STEPID] [int] NULL,
  [StepParameter_STEPName] [char](30) NOT NULL,
  [StepParameter_Type] [char](20) NULL,
  [StepParameter_Name] [char](50) NULL,
  [StepParameter_strValue] [char](80) NULL,
  [StepParameter_intValue] [int] NULL,
  [StepParameter_floatValue] [real] NULL,
  [StepParameter_Description] [char](80) NULL,
  [StepParameter_Object] [varchar](5000) NULL
)
GO