CREATE TABLE [dbo].[Counters] (
  [Counter_Code] [int] NOT NULL,
  [Counter_Name] [char](30) NOT NULL,
  [Last_Value] [int] NOT NULL,
  PRIMARY KEY CLUSTERED ([Counter_Code]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO