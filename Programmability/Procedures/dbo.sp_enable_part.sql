SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_enable_part]
-- Define input parameters
	@pname 		char(20) = NULL
	

-- Define code
AS	
	-- Define Local variables
	declare @pcount	int
	set @pcount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @pname is NULL
	   begin
		raiserror ('E115.1 Illegal Parameter Value. You must specify a part name.',
			16,1) with nowait
		return
	   end
	--See if Part exits
	if not exists(select Status from Catalog 
		where Part_No_Name=@pname)
	   begin
		raiserror ('E115.2 Illegal Parameter Value. Part %s does not exist.',
			16,1,@pname) with nowait
		return
	   end
	--See if Part is disabled
	if not exists(select Status from Catalog 
		where Part_No_Name=@pname and Status='D')
	   begin
		raiserror ('E115.3 Illegal Parameter Value. Part %s is not disabled.',
			16,1,@pname) with nowait
		return
	   end
	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the Catalog db
		-- Change part status to 'A'
		UPDATE Catalog		SET Status = 'A'		WHERE Part_No_Name = @pname

		if @@ERROR <>0
		   Begin
			raiserror('E115.4 Serious error. Unable to update status in Catalog db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO