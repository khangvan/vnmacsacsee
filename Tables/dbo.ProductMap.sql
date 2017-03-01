CREATE TABLE [dbo].[ProductMap] (
  [Digits] [char](3) NOT NULL,
  [Product_Name] [char](20) NOT NULL,
  [Product_Bit] [int] NOT NULL,
  [Top_Mod_Prefix] [char](5) NOT NULL,
  CONSTRAINT [PK_ProductMap] PRIMARY KEY CLUSTERED ([Digits]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductMap]
  ADD CONSTRAINT [FK_ProductMap_ProductBit] FOREIGN KEY ([Product_Bit]) REFERENCES [dbo].[ProductBit] ([Product_Bit])
GO