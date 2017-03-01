CREATE TABLE [dbo].[dlm_products] (
  [SAP_Count] [int] NOT NULL,
  [SAP_Model_Name] [char](20) NULL,
  [Format_Name] [char](20) NULL CONSTRAINT [DF_dlm_products_Format_Name] DEFAULT (null),
  [Status] [char](1) NULL CONSTRAINT [DF_dlm_products_Status] DEFAULT ('A')
)
ON [PRIMARY]
GO