CREATE TABLE [dbo].[dlm_catalog] (
  [Part_No_Count] [int] NOT NULL,
  [Part_No_Name] [char](20) NULL,
  [Description] [nchar](40) NULL CONSTRAINT [DF_dlm_catalog_Description] DEFAULT (null),
  [Status] [char](1) NOT NULL CONSTRAINT [DF_dlm_catalog_Status] DEFAULT ('A'),
  [FactoryGroup_Mask] [int] NULL,
  [ProductGroup_Mask] [int] NULL
)
ON [PRIMARY]
GO