CREATE TABLE [dbo].[SInterface] (
  [Class] [char](5) NOT NULL,
  [Digits] [char](5) NOT NULL,
  [Matrix_Value] [char](40) NULL
)
ON [PRIMARY]
GO

CREATE INDEX [IX_SInterface_Class]
  ON [dbo].[SInterface] ([Class])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

CREATE INDEX [IX_SInterface_digits]
  ON [dbo].[SInterface] ([Digits])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO