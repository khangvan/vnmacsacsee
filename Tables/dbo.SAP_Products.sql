CREATE TABLE [dbo].[SAP_Products] (
  [PRD_SAP_ID] [int] IDENTITY,
  [PRD_ProductHierarchy_ID] [int] NULL,
  [PRD_SAPModelName] [char](20) NOT NULL,
  [PRD_FormatName] [varchar](50) NULL,
  [PRD_Status] [char](1) NULL,
  CONSTRAINT [PK_SAP_Products] PRIMARY KEY CLUSTERED ([PRD_SAP_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[SAP_Products]
  ADD CONSTRAINT [FK_SAP_Products_SAP_ProductHierarchy] FOREIGN KEY ([PRD_ProductHierarchy_ID]) REFERENCES [dbo].[SAP_ProductHierarchy] ([PHR_ProductHierarchy_ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'PK', 'SCHEMA', N'dbo', 'TABLE', N'SAP_Products', 'COLUMN', N'PRD_SAP_ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'FK:SAP_ProductHierarchy', 'SCHEMA', N'dbo', 'TABLE', N'SAP_Products', 'COLUMN', N'PRD_ProductHierarchy_ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Name', 'SCHEMA', N'dbo', 'TABLE', N'SAP_Products', 'COLUMN', N'PRD_SAPModelName'
GO