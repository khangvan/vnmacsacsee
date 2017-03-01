CREATE TABLE [dbo].[SPCSpecMembers] (
  [specgroup_id] [int] NOT NULL,
  [sap_model_name] [char](20) NOT NULL,
  [spcsgs_date] [datetime] NOT NULL
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[SPCSpecMembers]
  ADD CONSTRAINT [FK_SPCSpecMembers_SPCSpecGroups] FOREIGN KEY ([specgroup_id]) REFERENCES [dbo].[SPCSpecGroups] ([specgroup_ID])
GO