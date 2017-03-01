CREATE TABLE [dbo].[SModel] (
  [Class] [char](5) NOT NULL,
  [Digits] [char](5) NOT NULL,
  [Matrix_Value] [char](40) NULL
)
ON [PRIMARY]
GO

CREATE INDEX [IX_SModel_Class]
  ON [dbo].[SModel] ([Class])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

CREATE INDEX [IX_SModel_digits]
  ON [dbo].[SModel] ([Digits])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO