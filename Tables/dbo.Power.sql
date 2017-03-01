CREATE TABLE [dbo].[Power] (
  [Class] [char](5) NOT NULL,
  [Digits] [char](5) NOT NULL,
  [Matrix_Value] [char](40) NULL
)
ON [PRIMARY]
GO

CREATE INDEX [IX_Power_Class]
  ON [dbo].[Power] ([Class])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IX_Power_digits]
  ON [dbo].[Power] ([Digits])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO