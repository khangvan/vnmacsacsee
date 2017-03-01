CREATE TABLE [dbo].[SAP_ProductHierarchy] (
  [PHR_ProductHierarchy_ID] [int] IDENTITY,
  [PHR_ProdFamily_ID] [int] NOT NULL,
  [PHR_ProductCategory_ID] [int] NOT NULL,
  [PHR_ProductHierarchy] [char](40) NULL,
  [PHR_SubGroup_ID] [int] NULL,
  CONSTRAINT [PK_SAP_ProductHierarchy] PRIMARY KEY CLUSTERED ([PHR_ProductHierarchy_ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[SAP_ProductHierarchy]
  ADD CONSTRAINT [FK_SAP_ProductHierarchy_SAP_ProductFamily] FOREIGN KEY ([PHR_ProdFamily_ID]) REFERENCES [dbo].[SAP_ProductFamily] ([PFM_ProductFamily_ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'PK', 'SCHEMA', N'dbo', 'TABLE', N'SAP_ProductHierarchy', 'COLUMN', N'PHR_ProductHierarchy_ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'FK:SAP_ProductFamily', 'SCHEMA', N'dbo', 'TABLE', N'SAP_ProductHierarchy', 'COLUMN', N'PHR_ProdFamily_ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'FK:SAP_ProductCategories', 'SCHEMA', N'dbo', 'TABLE', N'SAP_ProductHierarchy', 'COLUMN', N'PHR_ProductCategory_ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Name', 'SCHEMA', N'dbo', 'TABLE', N'SAP_ProductHierarchy', 'COLUMN', N'PHR_ProductHierarchy'
GO