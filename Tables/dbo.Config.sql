CREATE TABLE [dbo].[Config] (
  [Class] [char](5) NOT NULL,
  [Digits] [char](5) NOT NULL,
  [Matrix_Value] [char](40) NULL
)
ON [PRIMARY]
GO

CREATE INDEX [IX_Config_Class]
  ON [dbo].[Config] ([Class])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IX_Config_digits]
  ON [dbo].[Config] ([Digits])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO