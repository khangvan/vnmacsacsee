CREATE TABLE [dbo].[SPCSpecGroupStart] (
  [specgroup_ID] [int] NOT NULL,
  [STL_ID] [int] NOT NULL,
  [spc_date] [datetime] NOT NULL
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[SPCSpecGroupStart]
  ADD CONSTRAINT [FK_SPCSpecGroupStart_SPCSpecGroups] FOREIGN KEY ([specgroup_ID]) REFERENCES [dbo].[SPCSpecGroups] ([specgroup_ID])
GO