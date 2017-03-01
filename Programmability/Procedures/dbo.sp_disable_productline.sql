SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_disable_productline]
-- Define input parameters
	@tname 		char(5) = NULL -- Top_Model_No
	

-- Define code
AS	
	--Verify that non-NULLable parameter(s) have values
	if @tname is NULL
	   begin
		raiserror ('E302.1 Illegal Parameter Value. You must specify a Top Model Number Prefix.',
			16,1) with nowait
		return
	   end
	--See if Model exists
	if not exists(select Status from ProductLines 
		where Top_Model_Prfx=@tname and Status='A')
	   begin
		raiserror ('E302.2 Illegal Parameter Value. Active Top Model Prefix %s does not exist.',
			16,1,@tname) with nowait
		return
	   end
	
	-- See if Top Model exists in ACSSerialNumbers db
	if exists(select Top_Model_Prfx from ACSSerialNumbers
		where Top_Model_Prfx=@tname)
	   begin
		raiserror ('E302.3 Illegal Parameter Value. Top Model Prefix %s exists as part of a ACS Serial record. Use sp_purge_acs_serial first.',
			16,1,@tname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the ProductLines db
		-- Change model status to 'D'
		UPDATE ProductLines		SET Status = 'D'		WHERE Top_Model_Prfx = @tname

		if @@ERROR <>0
		   Begin
			raiserror('E302.4 Serious error. Unable to update status in ProductLines db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO