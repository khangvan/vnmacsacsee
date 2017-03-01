SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE proc [dbo].[sp_start_assembly]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@mname		char(20) = NULL, -- SAP_Model_No (get mcount from Products db)
	@sname		char(20) = NULL, -- Start_Station (get scount from Stations db)
	@tname		char(5) = NULL, -- Top_Model_No
	@sdate		datetime = NULL, -- Start_Mfg (called Ass_Date in ACSSerialNumbers db)
	@aseq		int = NULL	-- Last_ACS_Serial_Seq (ACSSerialNumbers db)-- Define code
AS

	--Define local variable(s)
	declare @id char(2)
	set @id = null
	declare @mcount int
	set @mcount = NULL
	declare @oldseq int
	set @oldseq = 0
	declare @scount int
	set @scount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		--raiserror ('E401.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
		--	16,1) with nowait
		return 2
	   end
	if @mname is NULL
	   begin
		--raiserror ('E401.2 Illegal Parameter Value. You must specify a SAP Model Number.',
			--16,1) with nowait
		return 3
	   end
	if @tname is NULL
	   begin -- We could extract the top model from the SAP Model Number, but well let the Emissary do that.
		--raiserror ('E401.3 Illegal Parameter Value. You must specify a Top Model Number.',
			--16,1) with nowait
		return 4
	   end
	if @sdate is NULL
	   begin -- we could assume today, but that might be a bad assumption...
		--raiserror ('E401.4 Illegal Parameter Value. You must specify an assignment date.',
			--16,1) with nowait
		return 5
	   end
	if @aseq is NULL
	   begin -- we could extract the sequence from the ACS Serial Number, but well let the Emissary do that.
		--raiserror ('E401.5 Illegal Parameter Value. You must specify a ACS Serial Sequence number for this station.',
			--16,1) with nowait
		return 6
	   end
	--See if ACS Serial Number allready exists
	if exists(select Start_Station from assemblies 
		where ACS_Serial=@aserial)
	   begin
		--raiserror ('E401.6 Illegal Parameter Value. ACS Serial Number %s allready exists.',
			--16,1,@aserial) with nowait
		return 7
	   end
	-- See if SAP Model Number exists
	if not exists(select Status from Products 
		where SAP_Model_Name=@mname and Status='A')
	   begin
		--raiserror ('E401.7 Illegal Parameter Value. Active Model Number %s does not exist.',
			--16,1,@mname) with nowait
		exec sp_create_label_format @mname
		--return 8
	   end
	select @mcount=SAP_Count from Products
		where SAP_Model_Name=@mname and Status='A'
	if @@ERROR <>0
	   begin
		--raiserror('E401.8 Undefined error. Unable to retrieve Products db data.',17,1)
		return 9
	   end

	-- See if Start Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		--raiserror ('E401.9 Illegal Parameter Value. Active Station %s does not exist.',
			--16,1,@sname) with nowait
		return 10
	   end
	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		--raiserror('E401.10 Undefined error. Unable to retrieve Stations db data.',17,1)
		return 11
	   end

	-- See if station is a start station
	--select @id=ACS_Serial_ID from Stations
	--	where Station_Name=@sname and Status='A'
	--if @@ERROR <>0
	--   begin
		--raiserror('E401.11 Undefined error. Unable to retrieve Stations db data.',17,1)
		--return 12
	--   end
	--if @id is null
	--   begin
		--raiserror('E401.12 Illegal Parameter Value. Station %s is not a start station.',
			--16,1,@sname)
		--return 13
	  -- end
	--if @id=''
	--   begin
		--raiserror('E401.13 Illegal Parameter Value. Station %s is not a start station.',
			--16,1,@sname)
	--	return 14
	--   end

	--See if Top Model Number exists
	--if not exists(select PSC_Serial_ID from ProductLines 
		--where Top_Model_Prfx=@tname and Status='A')
	   --begin
		--raiserror ('E401.14 Illegal Parameter Value. Active Top Model %s does not exist.',
			--16,1,@tname) with nowait
		--return 15
	  -- end
	
	-- See if Start Station is configured for this top model number
	--if not exists(select Last_ACS_Serial_Seq from ACSSerialNumbers 
		--where Start_Station=@scount and Top_Model_Prfx=@tname)
	 --  begin
		--raiserror ('E401.15 Illegal Parameter Value. This start station is not configured to start that top model number.',
			--16,1) with nowait
		--return 16
	 --  end

	--Begin T-SQL Transaction
	set LOCK_TIMEOUT 2000 -- wait upto 2 seconds for locked records to free up
	set transaction isolation level repeatable read --lock the db records!
	Begin Transaction
		--Get old counter for serial number
		--select @oldseq=Last_ACS_Serial_Seq from ACSSerialNumbers
			--where Start_Station=@scount and Top_Model_Prfx=@tname
		--if @@ERROR <>0
	   	 --  begin
			--raiserror('E401.16 Undefined error. Unable to retrieve ACSSerialNumbers db data.',17,1)
			--Rollback Transaction
			--return 17
	   	--   end
		--Save new assemblies db record
		Insert assemblies
		Values(@aserial, @mcount, @scount, @tname, @sdate, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT)
		if @@ERROR <> 0
		   begin
			--raiserror('E401.17 Serious Error. Failed to append record to assemblies db',17,1)
			Rollback Transaction
			return 18
		   end
		--update ACSSerialNumbers db record (make sure our value is greater than the old value
		--if @aseq>=@oldseq
		 -- begin
			--Update ACSSerialNumbers
			--set Last_ACS_Serial_Seq = @aseq, Assign_Date=@sdate
			--where Start_Station=@scount and Top_Model_Prfx=@tname
			--if @@ERROR <> 0
		   	--begin
				--raiserror('E401.18 Serious Error. Failed to modify record in ACSSerialNumbers db',17,1)
				--Rollback Transaction
				--return 19
		   	--end
		 --  end

	--Commit T-SQL transaction
	Commit Transaction
	return 1
-- Create the Stored Procedure
GO