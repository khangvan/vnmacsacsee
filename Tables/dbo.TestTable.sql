CREATE TABLE [dbo].[TestTable] (
  [test_id] [int] IDENTITY,
  [textvalue] [char](20) NULL,
  [intvalue] [int] NULL,
  CONSTRAINT [PK_TestTable] PRIMARY KEY CLUSTERED ([test_id])
)
ON [PRIMARY]
GO