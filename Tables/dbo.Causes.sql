CREATE TABLE [dbo].[Causes] (
  [RootCauses_Code] [char](3) NOT NULL,
  [RootCauses_Desc] [char](50) NULL,
  [ProductGroup_Mask] [int] NULL,
  [RootCause_Code] [char](4) NULL,
  CONSTRAINT [PK_Causes] PRIMARY KEY NONCLUSTERED ([RootCauses_Code]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Causes]
  ADD CONSTRAINT [FK_Causes_Cause] FOREIGN KEY ([RootCause_Code]) REFERENCES [dbo].[Cause] ([RootCause_Code])
GO