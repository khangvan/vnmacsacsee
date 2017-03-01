CREATE TABLE [dbo].[TestFailures] (
  [TL_ID] [int] NOT NULL,
  [Failure] [char](80) NULL
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[TestFailures] WITH NOCHECK
  ADD CONSTRAINT [FK_TestFailures_TestLog] FOREIGN KEY ([TL_ID]) REFERENCES [dbo].[TestLog] ([TL_ID])
GO