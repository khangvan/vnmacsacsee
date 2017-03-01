SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[uspProductBit]
	(
	@Product_Bit_Value int = null
	)
AS
set nocount on
if @Product_Bit_Value is null
	begin
		select 
			Product_Bit_Value, 
			Product_Desc
		from 
			[ACS EE].dbo.ProductBit
		order by
			Product_Desc asc
	end
else
	begin
		select 
			Product_Bit_Value, 
			Product_Desc
		from 
			[ACS EE].dbo.ProductBit
		where
			(Product_Bit_Value = @Product_Bit_Value)
	end
GO