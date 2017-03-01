SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_get_all_MaterialMap]

-- Define code
AS
	Select Digits, MaterialMap.Top_Model_Prfx, ProductLines.Product_Name from MaterialMap
	inner join ProductLines on MaterialMap.Top_Model_Prfx = ProductLines.Top_Model_Prfx
	order by Digits
	if @@ERROR <>0
	   begin
		raiserror('E314.1 Undefined error. Unable to retrieve MaterialMap db data.',17,1)
		return
	   end

-- Create the Stored Procedure


GO