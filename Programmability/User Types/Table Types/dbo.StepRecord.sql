CREATE TYPE [dbo].[StepRecord] AS TABLE (
  [STEP_ID] [int] NULL,
  [STEP_Name] [varchar](50) NOT NULL,
  [STEP_Type] [nchar](10) NULL,
  [STEP_TestName] [varchar](30) NOT NULL,
  [STEP_Model] [varchar](30) NOT NULL,
  [STEP_Order] [int] NOT NULL,
  [STEP_Parent] [varchar](50) NULL,
  [STEP_Description] [varchar](100) NULL
)
GO