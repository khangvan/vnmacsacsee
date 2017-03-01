CREATE TABLE [dbo].[BCS_Models] (
  [MODEL_ID] [int] IDENTITY,
  [MODEL_Name] [varchar](130) NULL,
  [MODEL_Description] [varchar](150) NULL,
  CONSTRAINT [PK_BCS_Models] PRIMARY KEY CLUSTERED ([MODEL_ID])
)
ON [PRIMARY]
GO