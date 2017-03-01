CREATE TABLE [dbo].[BCSBACKUP_BCS_Steps] (
  [STEP_ID] [int] NOT NULL,
  [STEP_Name] [varchar](150) NULL,
  [STEP_Type] [nchar](110) NULL,
  [STEP_TEST_ID] [int] NULL,
  [STEP_MODEL_ID] [int] NULL,
  [STEP_Parent_id] [int] NULL,
  [STEP_Order] [int] NULL,
  [STEP_Description] [varchar](100) NULL
)
ON [PRIMARY]
GO