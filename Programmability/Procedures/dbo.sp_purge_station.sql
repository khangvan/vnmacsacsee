SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_purge_station]
-- Define input parameters
	@sname 		char(20) = NULL
	

-- Define code
AS	
	-- Define Local variables
	declare @state	char(1)
	set @state = NULL

	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E3.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	--See if Station does not exist
	if not exists(select Station_Count from Stations 
		where Station_Name=@sname)
	   begin
		raiserror ('E3.2 Illegal Parameter Value. Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	--See if Station is 'disabled'
	if not exists(select Station_Count from Stations 
		where Station_Name=@sname and Status='D')
	   begin
		raiserror ('E3.3 Illegal Parameter Value. Station %s has not been disabled. You must use sp_disable_station first.',
			16,1,@sname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the Stations db
		-- Remove if station status is 'D'
		DELETE FROM Stations
		WHERE Station_Name = @sname and Status = 'D'

		if @@ERROR <>0
		   Begin
			raiserror('E3.4 Serious error. Unable to delete record in Stations db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO