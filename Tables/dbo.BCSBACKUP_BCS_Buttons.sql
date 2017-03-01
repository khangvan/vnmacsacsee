CREATE TABLE [dbo].[BCSBACKUP_BCS_Buttons] (
  [BCS_Button_ID] [int] NOT NULL,
  [BCS_Button_Name] [char](30) NULL,
  [BCS_Button_Type] [int] NULL,
  [BCS_Step_ID] [int] NULL,
  [BCS_Relationship] [int] NULL,
  [BCS_Notes] [varchar](50) NULL
)
ON [PRIMARY]
GO