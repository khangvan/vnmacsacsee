CREATE TABLE [dbo].[SPCMaps] (
  [Limit_ID] [int] NOT NULL,
  [specgroup_ID] [int] NOT NULL
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[SPCMaps]
  ADD CONSTRAINT [FK_SPCMaps_SPCSpecGroups] FOREIGN KEY ([specgroup_ID]) REFERENCES [dbo].[SPCSpecGroups] ([specgroup_ID])
GO