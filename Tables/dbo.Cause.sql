CREATE TABLE [dbo].[Cause] (
  [RootCause_Code] [char](4) NOT NULL,
  [RootCause_Desc] [char](50) NOT NULL,
  [Failure_Class] [char](20) NOT NULL,
  [ProductGroup_Mask] [int] NULL,
  CONSTRAINT [PK_RootCause] PRIMARY KEY NONCLUSTERED ([RootCause_Code])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Cause]
  ADD CONSTRAINT [FK_RootCause_FailureClass] FOREIGN KEY ([Failure_Class]) REFERENCES [dbo].[FailureClass] ([Failure_Class])
GO