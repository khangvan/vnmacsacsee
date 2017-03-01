CREATE TABLE [dbo].[BCS_Steps] (
  [STEP_ID] [int] IDENTITY,
  [STEP_Name] [varchar](150) NULL,
  [STEP_Type] [nchar](110) NULL,
  [STEP_TEST_ID] [int] NULL,
  [STEP_MODEL_ID] [int] NULL,
  [STEP_Parent_id] [int] NULL,
  [STEP_Order] [int] NULL,
  [STEP_Description] [varchar](100) NULL,
  CONSTRAINT [PK_BCS_Steps] PRIMARY KEY CLUSTERED ([STEP_ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[BCS_Steps]
  ADD CONSTRAINT [FK_BCS_Steps_BCS_Models] FOREIGN KEY ([STEP_MODEL_ID]) REFERENCES [dbo].[BCS_Models] ([MODEL_ID])
GO

ALTER TABLE [dbo].[BCS_Steps]
  ADD CONSTRAINT [FK_BCS_Steps_BCS_Test] FOREIGN KEY ([STEP_TEST_ID]) REFERENCES [dbo].[BCS_Test] ([TEST_ID])
GO