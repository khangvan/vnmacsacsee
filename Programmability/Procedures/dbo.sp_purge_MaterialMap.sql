SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_purge_MaterialMap]
-- Define input parameters
	@digits 		char(5) = NULL
	

-- Define code
AS	
	--Verify that non-NULLable parameter(s) have values
	if @digits is NULL
	   begin
		raiserror ('E313.1 Illegal Parameter Value. You must specify some digits.',
			16,1) with nowait
		return
	   end
	--See if digits exist
	if not exists(select * from MaterialMap 
		where Digits=@digits)
	   begin
		raiserror ('E313.2 Illegal Parameter Value. Digit %s does not exist.',
			16,1,@digits) with nowait
		return
	   end
	
	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the MaterialMap db
		DELETE FROM MaterialMap
		WHERE Digits = @digits

		if @@ERROR <>0
		   Begin
			raiserror('E313.3 Serious error. Unable to delete record in MaterialMap db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO