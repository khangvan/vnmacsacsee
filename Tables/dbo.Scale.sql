CREATE TABLE [dbo].[Scale] (
  [Class] [char](5) NOT NULL,
  [Digits] [char](5) NOT NULL,
  [Matrix_Value] [char](40) NULL
)
ON [PRIMARY]
GO

CREATE INDEX [IX_Scale_Class]
  ON [dbo].[Scale] ([Class])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

CREATE INDEX [IX_Scale_digits]
  ON [dbo].[Scale] ([Digits])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO