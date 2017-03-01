CREATE TABLE [dbo].[BCS_Buttons] (
  [BCS_Button_ID] [int] IDENTITY,
  [BCS_Button_Name] [char](30) NULL,
  [BCS_Button_Type] [int] NULL,
  [BCS_Step_ID] [int] NULL,
  [BCS_Relationship] [int] NULL,
  [BCS_Notes] [varchar](50) NULL,
  CONSTRAINT [PK_BCS_Buttons] PRIMARY KEY CLUSTERED ([BCS_Button_ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[BCS_Buttons] WITH NOCHECK
  ADD CONSTRAINT [FK_BCS_Buttons_BCS_Steps] FOREIGN KEY ([BCS_Step_ID]) REFERENCES [dbo].[BCS_Steps] ([STEP_ID])
GO

ALTER TABLE [dbo].[BCS_Buttons]
  NOCHECK CONSTRAINT [FK_BCS_Buttons_BCS_Steps]
GO