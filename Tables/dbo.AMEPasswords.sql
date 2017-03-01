CREATE TABLE [dbo].[AMEPasswords] (
  [User_Name] [char](20) NOT NULL,
  [Pass_Word] [char](20) NOT NULL,
  [Pw_ID] [int] IDENTITY
)
ON [PRIMARY]
GO

CREATE UNIQUE CLUSTERED INDEX [passwordindex]
  ON [dbo].[AMEPasswords] ([User_Name])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO