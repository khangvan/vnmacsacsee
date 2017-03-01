CREATE TYPE [dbo].[Buttons] AS TABLE (
  [BUTTON_ID] [int] NULL,
  [BUTTON_NAME] [char](30) NULL,
  [BUTTON_TYPE] [int] NULL,
  [BUTTON_STEP_ID] [int] NULL,
  [BUTTON_Relationship] [int] NULL,
  [BUTTON_Notes] [char](50) NULL
)
GO