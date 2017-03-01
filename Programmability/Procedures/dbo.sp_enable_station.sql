SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_enable_station]
-- Define input parameters
	@sname 		char(20) = NULL
	

-- Define code
AS	
	-- Define Local variables
	declare @scount	int
	set @scount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E15.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	--See if Station exits
	if not exists(select Status from Stations 
		where Station_Name=@sname)
	   begin
		raiserror ('E15.2 Illegal Parameter Value. Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	--See if Station is disabled
	if not exists(select Status from Stations 
		where Station_Name=@sname and Status='D')
	   begin
		raiserror ('E15.3 Illegal Parameter Value. Station %s is not disabled.',
			16,1,@sname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the Stations db
		-- Change station status to 'A'
		UPDATE Stations		SET Status = 'A'		WHERE Station_Name = @sname

		if @@ERROR <>0
		   Begin
			raiserror('E15.3 Serious error. Unable to update status in Stations db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO