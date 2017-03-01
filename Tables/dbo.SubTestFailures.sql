CREATE TABLE [dbo].[SubTestFailures] (
  [Test_ID] [char](50) NOT NULL,
  [SubTest_Name] [char](30) NOT NULL,
  [STF_ID] [int] IDENTITY,
  CONSTRAINT [PK_SubTestFailures] PRIMARY KEY CLUSTERED ([STF_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

CREATE INDEX [testid]
  ON [dbo].[SubTestFailures] ([Test_ID])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO