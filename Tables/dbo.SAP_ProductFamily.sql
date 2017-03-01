CREATE TABLE [dbo].[SAP_ProductFamily] (
  [PFM_ProductFamily_ID] [int] IDENTITY,
  [PFM_ProductFamily] [nvarchar](150) NULL,
  [PFM_PRoductReportGroup_ID] [int] NULL,
  CONSTRAINT [PK_SAP_ProductFamily] PRIMARY KEY CLUSTERED ([PFM_ProductFamily_ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'PK', 'SCHEMA', N'dbo', 'TABLE', N'SAP_ProductFamily', 'COLUMN', N'PFM_ProductFamily_ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Name', 'SCHEMA', N'dbo', 'TABLE', N'SAP_ProductFamily', 'COLUMN', N'PFM_ProductFamily'
GO