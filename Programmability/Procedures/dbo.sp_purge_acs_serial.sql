SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_purge_acs_serial]
-- Define input parameters
	@sname 		char(20) = NULL, @tname		char(5) = NULL
-- Define code
AS
	--Define local variable(s)
	declare @scount int
	set @scount = NULL
	
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E308.1 Illegal Parameter Value. You must specify a Start Station Name.',
			16,1) with nowait
		return
	   end
	if @tname is NULL
	   begin
		raiserror ('E308.2 Illegal Parameter Value. You must specify a Top Model Number Prefix.',
			16,1) with nowait
		return
	   end

	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		raiserror ('E308.3 Illegal Parameter Value. Active Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E308.4 Undefined error. Unable to retrieve Stations db data.',17,1)
		return
	   end

	--Begin T-SQL Transaction
	Begin Transaction
		--Remove specific ACSSerialNumbers db record(s)
		Delete from ACSSerialNumbers
		where Start_Station=@scount and Top_Model_Prfx=@tname
		if @@ERROR <> 0
		   begin
			raiserror('E308.5 Serious Error. Failed to delete record in ACSSerialNumbers db',17,1)
			Rollback Transaction
			return
		   end
	--Commit T-SQL transaction
	Commit Transaction
-- Create the Stored Procedure


GO