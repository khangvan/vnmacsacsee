CREATE TABLE [dbo].[Interface] (
  [Class] [char](5) NOT NULL,
  [Digits] [char](5) NOT NULL,
  [Matrix_Value] [char](40) NULL
)
ON [PRIMARY]
GO

CREATE INDEX [IX_Interface_Class]
  ON [dbo].[Interface] ([Class])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IX_Interface_digits]
  ON [dbo].[Interface] ([Digits])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO