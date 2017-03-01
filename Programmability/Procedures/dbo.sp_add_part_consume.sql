SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



CREATE proc [dbo].[sp_add_part_consume]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@pname		char(20) = NULL, -- Part_No_Name (in Catalog db)
	@sname		char(20) = NULL, -- Station_Name (from Stations db)
	@adate		datetime = NULL, -- date filled
	@qadded		int = 1, 	-- Quanitity_Filled
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
		--raiserror ('E403.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			--16,1) with nowait
		return 2
	   end
	if @pname is NULL
	   begin
		--raiserror ('E403.2 Illegal Parameter Value. You must specify a Part Number Name.',
			--16,1) with nowait
		return 3
	   end
	if @sname is NULL
	   begin
		--raiserror ('E403.4 Illegal Parameter Value. You must specify a station name.',
			--16,1) with nowait
		return 4
	   end
	if @adate is NULL
	   begin
		--raiserror ('E403.5 Illegal Parameter Value. You must specify an add date.',
			--16,1) with nowait
		return 5
	   end



	--See if assembly exists
	--if not exists(select Start_Station from assemblies 
		--where ACS_Serial=@aserial)
	  -- begin
		--raiserror ('E403.6 Illegal Parameter Value. Assembly %s does not exist.',
			--16,1,@aserial) with nowait
		--return 6
	   --end
	--See if part exists
	if not exists(select Part_No_Count from Catalog 
		where Part_No_Name=@pname and Status='A')
	   begin
		--raiserror ('E403.7 Illegal Parameter Value. Active Part %s does not exist.',
			--16,1,@pname) with nowait
		return 7
	   end
	select @pcount=Part_No_Count from Catalog
		where Part_No_Name=@pname and Status='A'
	if @@ERROR <>0
	   begin
		--raiserror('E403.8 Undefined error. Unable to retrieve Catalog db data.',17,1)
		return 8
	   end
	--See if station exists
	if not exists(select Station_Count from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		--raiserror ('E403.9 Illegal Parameter Value. Active Station %s does not exist.',
			--16,1,@sname) with nowait
		return 9
	   end
	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		--raiserror('E403.10 Undefined error. Unable to retrieve Station db data.',17,1)
		return 10
	   end
	-- See if this station is setup to control this part
	--if not exists(select Fill_Quantity from Partlist 
	--	where Part_No=@pcount and Station=@scount)
	 --  begin
		--raiserror ('E403.11 Illegal Parameter Value. Part is not controlled at this station.',
			--16,1) with nowait
		--return 11
	   --end
	-- Get old quantity filled value
--	select @oldq = Quantity_Filled from Travellers
--		where ACS_Serial=@aserial and Part_No=@pcount
--	if @@ERROR <> 0
--	   begin
--		raiserror('E403.12 Serious Error. Failed to get data from travellers db',17,1)
--		return
--	   end
--	set @newfilled = @oldq + @qadded
	--Begin T-SQL Transaction
	Begin Transaction
		--Save new asylog db record
		Insert asylog
		Values(@aserial, @scount, 403, @pcount, @sserial, @rev, @adate, @qadded)
		if @@ERROR <> 0
		   begin
			--raiserror('E403.13 Serious Error. Failed to append record to assemblies db',17,1)
			Rollback Transaction
			return 12
		   end
		--Update Travellers db
--		update Travellers
--		set Quantity_Filled = @newfilled
--		where ACS_Serial=@aserial and Part_No=@pcount
--		if @@ERROR <> 0
--		   begin
--			raiserror('E403.14 Serious Error. Failed to update record in travellers db',17,1)
--			Rollback Transaction
--			return
--		   end
	--Commit T-SQL transaction
	Commit Transaction
	return 1
-- Create the Stored Procedure
GO