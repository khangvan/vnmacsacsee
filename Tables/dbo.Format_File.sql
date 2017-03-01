CREATE TABLE [dbo].[Format_File] (
  [Class] [char](5) NOT NULL,
  [Digits] [char](5) NOT NULL,
  [Label_Format_Prefix] [char](20) NOT NULL,
  [Type_Byte] [int] NOT NULL,
  [select_value] [smallint] NULL
)
ON [PRIMARY]
GO

CREATE INDEX [IX_Format_File_Class]
  ON [dbo].[Format_File] ([Class])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IX_Format_File_digits]
  ON [dbo].[Format_File] ([Digits])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO