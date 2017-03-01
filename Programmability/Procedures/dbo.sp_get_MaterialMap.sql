SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_get_MaterialMap]
-- Define input parameters
	@digits 		char(5) = NULL

-- Define code
AS
	--Verify that non-NULLable parameter(s) have values
	if @digits is NULL
	   begin
		raiserror ('E311.1 Illegal Parameter Value. You must specify some digits.',
			16,1) with nowait
		return
	   end

	--See if digits exists
	if not exists(select * from MaterialMap 
		where Digits=@digits)
	   begin
		raiserror ('E311.2 Illegal Parameter Value. Digits %s do not exist.',
			16,1,@digits) with nowait
		return
	   end

	-- Get digit information
	select MaterialMap.Digits, MaterialMap.Top_Model_Prfx,ProductLines.Product_Name from MaterialMap
	inner join ProductLines on MaterialMap.Top_Model_Prfx=ProductLines.Top_Model_Prfx
	where MaterialMap.Digits=@digits
	if @@ERROR <>0
	   begin
		raiserror('E311.3 Undefined error. Unable to retrieve MaterialMap db data.',17,1)
		return
	   end

-- Create the Stored Procedure


GO