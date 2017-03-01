SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_test_assembly]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@sname		char(20) = NULL, -- Station_Name (from Stations db)
	@adate		datetime = NULL, -- date filled
	@pname		char(20) = NULL, -- Part_No_Name (in Catalog db)
	@sserial	char(20) = NULL, -- Scanned component serial number
	@rev		char(2) = NULL -- Rev (version)
	
-- Define code
AS
	--Define local variable(s)
	declare @scount int -- station
	set @scount = NULL
	declare @pcount int -- part
	set @pcount = NULL
	declare @oldq int
	set @oldq = 0
	declare @newfilled int
	set @newfilled = 0
	
	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		raiserror ('E405.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			16,1) with nowait
		return
	   end
	if @sname is NULL
	   begin
		raiserror ('E405.2 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	if @adate is NULL
	   begin
		raiserror ('E405.3 Illegal Parameter Value. You must specify a test date.',
			16,1) with nowait
		return
	   end

	--See if assembly exists
	if not exists(select Start_Station from assemblies 
		where ACS_Serial=@aserial)
	   begin
		raiserror ('E405.4 Illegal Parameter Value. Assembly %s does not exist.',
			16,1,@aserial) with nowait
		return
	   end
	--See if part exists (not every test station is given configuration files)
	if @pname is not null
	   begin
		if not exists(select Part_No_Count from Catalog 
			where Part_No_Name=@pname and Status='A')
	   	   begin
			raiserror ('E405.5 Illegal Parameter Value. Active Part %s does not exist.',
				16,1,@pname) with nowait
			return
	   	   end
		select @pcount=Part_No_Count from Catalog
			where Part_No_Name=@pname and Status='A'
		if @@ERROR <>0
	  	   begin
			raiserror('E405.6 Undefined error. Unable to retrieve Catalog db data.',17,1)
			return
	   	   end
	   end
	--See if station exists and is a test station
	if not exists(select Station_Count from Stations 
		where Station_Name=@sname and Perform_Test='Y' and Status='A')
	   begin
		raiserror ('E405.7 Illegal Parameter Value. Active Test Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E405.8 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end
	-- See if this station is setup to control this part
	if @pname is not null --not every test station has a part
	   begin
		if not exists(select Fill_Quantity from Partlist 
			where Part_No=@pcount and Station=@scount)
	   	   begin
			raiserror ('E405.9 0Illegal Parameter Value. Part is not controlled at this station.',
				16,1) with nowait
			return
	   	   end
	   end
	--Begin T-SQL Transaction
	Begin Transaction
		--Save new asylog db record
		Insert asylog
		Values(@aserial, @scount, 405, @pcount, @sserial, @rev, @adate, 1)
		if @@ERROR <> 0
		   begin
			raiserror('E405.10 Serious Error. Failed to append record to assemblies db',17,1)
			Rollback Transaction
			return
		   end
		--Update Travellers db
		if @pname is not null -- not every test station uses a part
		   begin
			update Travellers
			set Quantity_Filled = 1 -- test stations will only get the config file once!!!
			where ACS_Serial=@aserial and Part_No=@pcount
			if @@ERROR <> 0
		   	   begin
				raiserror('E405.11 Serious Error. Failed to update record in travellers db',17,1)
				Rollback Transaction
				return
		   	   end
		   end
	--Commit T-SQL transaction
	Commit Transaction
-- Create the Stored Procedure


GO