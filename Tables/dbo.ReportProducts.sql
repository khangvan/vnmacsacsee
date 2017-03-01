CREATE TABLE [dbo].[ReportProducts] (
  [PRD_SAP_ID] [int] NOT NULL,
  [PRD_ProductHierarchy_ID] [int] NULL,
  [PRD_SAPModelName] [char](20) NOT NULL,
  [PRD_FormatName] [varchar](50) NULL,
  [PRD_Status] [char](1) NULL
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'PK', 'SCHEMA', N'dbo', 'TABLE', N'ReportProducts', 'COLUMN', N'PRD_SAP_ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'FK:SAP_ProductHierarchy', 'SCHEMA', N'dbo', 'TABLE', N'ReportProducts', 'COLUMN', N'PRD_ProductHierarchy_ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Name', 'SCHEMA', N'dbo', 'TABLE', N'ReportProducts', 'COLUMN', N'PRD_SAPModelName'
GO