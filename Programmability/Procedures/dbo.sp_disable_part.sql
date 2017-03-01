SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_disable_part]
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
		raiserror ('E0001.0201 Illegal Parameter Value. You must specify a part name.',
			16,1) with nowait
		return
	   end
	--See if Part does not exist
	if not exists(select Status from Catalog 
		where Part_No_Name=@pname)
	   begin
		raiserror ('E0001.0202 Illegal Parameter Value. Part %s does not exist.',
			16,1,@pname) with nowait
		return
	   end
	-- Obtain Part_Count value for testing
	select @pcount=Part_No_Count from Catalog 
		where Part_No_Name=@pname
	if @@ERROR <>0
	   Begin
		raiserror('E0001.0203 Serious error. Unable to obtain pcount from Catalog db',17,1)
		return
	   End

	-- See if Part exists in Partlist db
	if exists(select Part_No from Partlist
		where Part_No=@pcount)
	   begin
		raiserror ('E0001.0204 Illegal Parameter Value. Part %s exists as part of a Partlist. Use sp_purge_part_control first.',
			16,1,@pname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the Catalog db
		-- Change part status to 'D'
		UPDATE Catalog		SET Status = 'D'		WHERE Part_No_Name = @pname

		if @@ERROR <>0
		   Begin
			raiserror('E0001.0205 Serious error. Unable to update status in Catalog db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO