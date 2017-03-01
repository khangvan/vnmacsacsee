SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_modify_part]
-- Define input parameters
	@pname 		char(20) = NULL, @ndesc 	nchar(40) = NULL -- Catalog db
		  -- must use other stored proceedures to modify Status field
	
-- Define code
AS
	--Verify that non-NULLable parameter(s) have values
	if @pname is NULL
	   begin
		raiserror ('E104.1 Illegal Parameter Value. You must specify a part name.',
			16,1) with nowait
		return
	   end
	--See if Catalog exists
	if not exists(select Status from Catalog 
		where Part_No_Name=@pname)
	   begin
		raiserror ('E104.2 Illegal Parameter Value. Part %s does not exist.',
			16,1,@pname) with nowait
		return
	   end
	-- Begin transaction
	Begin Transaction
		-- Update Catalog db record
		update Catalog -- Note that Status does not get update here!
		SET Description=@ndesc	
		where Part_No_Name=@pname
		if @@ERROR <> 0
	   	   begin
			raiserror ('E104.3 Update Error. Unable to update Catalog db record.',17,1)
			rollback transaction
			return
		   end

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO