CREATE TABLE [dbo].[PartType] (
  [Result_Digits] [char](5) NOT NULL,
  [Description_Parse_Value] [char](30) NOT NULL,
  [Check_Order] [int] NOT NULL,
  CONSTRAINT [PK_PartType] PRIMARY KEY CLUSTERED ([Result_Digits]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO