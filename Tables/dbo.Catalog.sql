CREATE TABLE [dbo].[Catalog] (
  [Part_No_Count] [int] NOT NULL,
  [Part_No_Name] [char](20) NULL,
  [Description] [nchar](40) NULL CONSTRAINT [DF_Catalog_Description] DEFAULT (null),
  [Status] [char](1) NOT NULL CONSTRAINT [DF_Catalog_Status] DEFAULT ('A'),
  [FactoryGroup_Mask] [int] NULL,
  [ProductGroup_Mask] [int] NULL,
  [RegEx] [varchar](150) NULL,
  CONSTRAINT [PK_Catalog] PRIMARY KEY NONCLUSTERED ([Part_No_Count]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO