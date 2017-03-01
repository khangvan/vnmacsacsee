CREATE TABLE [dbo].[FFC_BAK_Catalog] (
  [Part_No_Count] [int] NOT NULL,
  [Part_No_Name] [char](20) NULL,
  [Description] [nchar](40) NULL CONSTRAINT [DF_FFC_BAK_Catalog_Description] DEFAULT (null),
  [Status] [char](1) NOT NULL CONSTRAINT [DF_FFC_BAK_Catalog_Status] DEFAULT ('A'),
  [FactoryGroup_Mask] [int] NULL,
  [ProductGroup_Mask] [int] NULL
)
ON [PRIMARY]
GO