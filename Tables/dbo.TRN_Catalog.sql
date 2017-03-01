CREATE TABLE [dbo].[TRN_Catalog] (
  [Part_No_Count] [int] NOT NULL,
  [Part_No_Name] [char](20) NULL,
  [Description] [nchar](40) NULL CONSTRAINT [DF_TRN_Catalog_Description] DEFAULT (null),
  [Status] [char](1) NOT NULL CONSTRAINT [DF_TRN_Catalog_Status] DEFAULT ('A'),
  [FactoryGroup_Mask] [int] NULL,
  [ProductGroup_Mask] [int] NULL,
  CONSTRAINT [PK_TRN_Catalog] PRIMARY KEY CLUSTERED ([Part_No_Count])
)
ON [PRIMARY]
GO