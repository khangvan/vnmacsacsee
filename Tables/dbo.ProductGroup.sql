CREATE TABLE [dbo].[ProductGroup] (
  [ProductGroup_Byte] [int] NOT NULL,
  [ProductGroup_Name] [char](30) NOT NULL,
  CONSTRAINT [PK_ProductGroup] PRIMARY KEY NONCLUSTERED ([ProductGroup_Byte]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO