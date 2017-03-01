SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_purge_productline]
-- Define input parameters
	@tname 		char(5) = NULL
	

-- Define code
AS	
	--Verify that non-NULLable parameter(s) have values
	if @tname is NULL
	   begin
		raiserror ('E303.1 Illegal Parameter Value. You must specify a Top Model Number Prefix.',
			16,1) with nowait
		return
	   end
	--See if Top Model Number exists
	if not exists(select Status from ProductLines 
		where Top_Model_Prfx=@tname)
	   begin
		raiserror ('E303.2 Illegal Parameter Value. Top Model Prefix %s does not exist.',
			16,1,@tname) with nowait
		return
	   end
	--See if Model is 'disabled'
	if not exists(select Status from ProductLines 
		where Top_Model_Prfx=@tname and Status='D')
	   begin
		raiserror ('E303.3 Illegal Parameter Value. Top Model Prefix %s has not been disabled.',
			16,1,@tname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the ProductLines db
		-- Remove if part status is 'D'
		DELETE FROM ProductLines
		WHERE Top_Model_Prfx = @tname and Status = 'D'

		if @@ERROR <>0
		   Begin
			raiserror('E303.4 Serious error. Unable to delete record in ProductLines db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO