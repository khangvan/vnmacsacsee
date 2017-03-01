SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_create_MaterialMap]
-- Define input parameters
	@digits 	char(5) = NULL, @tname char(5) = NULL
	
-- Define code
AS
	--Verify that non-NULLable parameter(s) have values
	if @digits is NULL
	   begin
		raiserror ('E312.1 Illegal Parameter Value. You must specify some digits.',
			16,1) with nowait
		return
	   end
	if @tname is NULL
	   begin
		raiserror ('E312.2 Illegal Parameter Value. You must specify a Top Model Prefix.',
			16,1) with nowait
		return
	   end
	--See if Digit already exists
	if exists(select * from MaterialMap 
		where Digits=@digits)
	   begin
		raiserror ('E312.3 Illegal Parameter Value. Digit %s already exists.',
			16,1,@digits) with nowait
		return
	   end

	--See if prefix exists
	if not exists(select * from ProductLines 
		where Top_Model_Prfx=@tname)
	   begin
		raiserror ('E312.4 Illegal Parameter Value. Top Model Prefix %s does not exist.',
			16,1,@tname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction
		-- Save record to MaterialMap db
		Insert MaterialMap
		Values (@tname, @digits)
		if @@ERROR <> 0
		   Begin
			raiserror('E312.5 Serious error. Failed to append to MaterialMap db',17,1)
			Rollback Transaction
			Return
		   End
	
	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO