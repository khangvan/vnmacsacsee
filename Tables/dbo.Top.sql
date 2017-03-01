CREATE TABLE [dbo].[Top] (
  [Class] [char](5) NOT NULL,
  [Digits] [char](5) NOT NULL,
  [Matrix_Value] [char](40) NULL
)
ON [PRIMARY]
GO

CREATE INDEX [IX_Top_Class]
  ON [dbo].[Top] ([Class])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

CREATE INDEX [IX_Top_digits]
  ON [dbo].[Top] ([Digits])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO