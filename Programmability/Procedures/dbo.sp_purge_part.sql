SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_purge_part]
-- Define input parameters
	@pname 		char(20) = NULL
	

-- Define code
AS	
	--Verify that non-NULLable parameter(s) have values
	if @pname is NULL
	   begin
		raiserror ('E0001.0301 Illegal Parameter Value. You must specify a part name.',
			16,1) with nowait
		return
	   end
	--See if Part does not exist
	if not exists(select Part_No_Count from Catalog 
		where Part_No_Name=@pname)
	   begin
		raiserror ('E0001.0302 Illegal Parameter Value. Part %s does not exist.',
			16,1,@pname) with nowait
		return
	   end
	--See if Part is 'disabled'
	if not exists(select Part_No_Count from Catalog 
		where Part_No_Name=@pname and Status='D')
	   begin
		raiserror ('E0001.0303 Illegal Parameter Value. Part %s has not been disabled. You must use sp_disable_part first.',
			16,1,@pname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the Catalog db
		-- Remove if part status is 'D'
		DELETE FROM Catalog
		WHERE Part_No_Name = @pname and Status = 'D'

		if @@ERROR <>0
		   Begin
			raiserror('E0001.0304 Serious error. Unable to delete record in Catalog db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO