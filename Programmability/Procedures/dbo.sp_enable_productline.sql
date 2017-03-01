SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_enable_productline]
-- Define input parameters
	@tname 		char(5) = NULL -- Top_Model_No Prefix
	

-- Define code
AS	
	--Verify that non-NULLable parameter(s) have values
	if @tname is NULL
	   begin
		raiserror ('E315.1 Illegal Parameter Value. You must specify an Top Model Prefix.',
			16,1) with nowait
		return
	   end
	--See if product line exists
	if not exists(select Status from ProductLines 
		where Top_Model_Prfx=@tname)
	   begin
		raiserror ('E315.2 Illegal Parameter Value. Top Model Prefix %s does not exist.',
			16,1,@tname) with nowait
		return
	   end
	--See if product line is disabled
	if not exists(select Status from ProductLines 
		where Top_Model_Prfx=@tname and Status='D')
	   begin
		raiserror ('E315.3 Illegal Parameter Value. Product Line %s is not disabled.',
			16,1,@tname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the ProductLines db
		-- Change model status to 'A'
		UPDATE ProductLines		SET Status = 'A'		WHERE Top_Model_Prfx = @tname

		if @@ERROR <>0
		   Begin
			raiserror('E315.4 Serious error. Unable to update status in ProductLines db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO