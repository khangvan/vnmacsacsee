SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_disable_station]
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
		raiserror ('E2.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	--See if Station does not exist
	if not exists(select Status from Stations 
		where Station_Name=@sname)
	   begin
		raiserror ('E2.2 Illegal Parameter Value. Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	-- Obtain Station_Count value for testing
	select @scount=Station_Count from Stations 
		where Station_Name=@sname
	if @@ERROR <>0
	   Begin
		raiserror('E2.3 Serious error. Unable to obtain scount from Stations db',17,1)
		return
	   End

	-- See if Station exists in Lines db
	if exists(select Station from Lines
		where Station=@scount or Next_Station=@scount)
	   begin
		raiserror ('E2.4 Illegal Parameter Value. Station %s exists as part of a line. Use sp_purge_line first.',
			16,1,@sname) with nowait
		return
	   end
	-- See if Station exists in PartList db
	if exists(select Station from PartList
		where Station=@scount)
	   begin
		raiserror ('E2.5 Illegal Parameter Value. Station %s Has controlled parts.',
			16,1,@sname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the Stations db
		-- Change station status to 'D'
		UPDATE Stations		SET Status = 'D'		WHERE Station_Name = @sname

		if @@ERROR <>0
		   Begin
			raiserror('E2.6 Serious error. Unable to update status in Stations db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO