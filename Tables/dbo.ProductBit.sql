CREATE TABLE [dbo].[ProductBit] (
  [Product_Bit_Value] [int] NOT NULL,
  [Product_Bit] [int] NOT NULL,
  [Product_Name] [char](20) NOT NULL,
  [Product_Desc] [char](50) NOT NULL,
  CONSTRAINT [PK_ProductBit] PRIMARY KEY CLUSTERED ([Product_Bit]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO