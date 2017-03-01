SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



CREATE proc [dbo].[sp_psc_serial_assignment]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@pserial	char(20) = NULL, -- PSC_Serial
	@fname		char(20) = NULL, -- Finish_Station (get scount from Stations db)
	@tname		char(5) = NULL, -- Top_Model_No (ProductLines db)
	@pseq		int = NULL	-- Last_PSC_Serial_Seq (ProductLines db)-- Define code
AS

	--Define local variable(s)
	declare @psctest char(1)
	set @psctest=null
	declare @oldseq int
	set @oldseq = 0
	declare @fcount int
	set @fcount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		--raiserror ('E402.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
		--	16,1) with nowait
		return 2
	   end
	if @pserial is NULL
	   begin
		--raiserror ('E402.2 Illegal Parameter Value. You must specify an PSC Serial Number.',
		--	16,1) with nowait
		return 3
	   end
	if @fname is NULL
	   begin
		--raiserror ('E402.3 Illegal Parameter Value. You must specify a Finish Station.',
		--	16,1) with nowait
		return 4
	   end
	if @tname is NULL
	   begin -- We could extract the top model from the SAP Model Number, but well let the Emissary do that.
		--raiserror ('E402.4 Illegal Parameter Value. You must specify a Top Model Number.',
			--16,1) with nowait
		return 5
	   end
	if @pseq is NULL
	   begin -- we could extract the sequence from the PSC Serial Number, but well let the Emissary do that.
		--raiserror ('E402.5 Illegal Parameter Value. You must specify a PSC Serial Sequence number for this station.',
			--16,1) with nowait
		return 6
	   end
	--See if ACS Serial Number exists
	if not exists(select Start_Station from assemblies 
		where ACS_Serial=@aserial)
	   begin
		--raiserror ('E402.6 Illegal Parameter Value. ACS Serial Number %s does not exist.',
			--16,1,@aserial) with nowait
		return 7
	   end
	--See if PSC Serial Number already exists
	if exists(select Start_Station from assemblies 
		where PSC_Serial=@pserial)
	   begin
		--raiserror ('E402.7 Illegal Parameter Value. PSC Serial Number %s already exits.',
			--16,1,@pserial) with nowait
		return 8
	   end
	
	-- See if Finish Station exists
	if not exists(select Status from Stations 
		where Station_Name=@fname and Status='A')
	   begin
		--raiserror ('E402.8 Illegal Parameter Value. Active Station %s does not exist.',
			--16,1,@fname) with nowait
		return 9
	   end
	select @fcount=Station_Count, @psctest=Gen_PSC_Serial from Stations
		where Station_Name=@fname and Status='A'
	if @@ERROR <>0
	   begin
		--raiserror('E402.9 Undefined error. Unable to retrieve Stations db data.',17,1)
		return 10
	   end
	--if @psctest<>'Y'
	  -- begin
		--raiserror('E402.10 Illegal Parameter Value. Station %s does not have the ability to generate PSC serial numbers.',
			--16,1,@fname)
		--return 11
	--   end
	--See if Top Model Number exists
	--if not exists(select PSC_Serial_ID from ProductLines 
		--where Top_Model_Prfx=@tname and Status='A')
	--   begin
		--raiserror ('E402.11 Illegal Parameter Value. Active Top Model %s does not exist.',
			--16,1,@tname) with nowait
		--return 12
	 --  end
	
	-- See if Finish Station is configured for this top model number
	--if not exists(select Last_PSC_Serial_Seq from ProductLines 
		--where PSCGen_Station=@fcount and Top_Model_Prfx=@tname and Status='A')
	  -- begin
		--raiserror ('E402.12 Illegal Parameter Value. This Finish station is not configured to assign PSC SN to that top model number.',
			--16,1) with nowait
		--return 13
	  -- end

	--Begin T-SQL Transaction
	set LOCK_TIMEOUT 2000 -- wait upto 2 seconds for locked records to free up
	set transaction isolation level repeatable read --lock the db records!
	Begin Transaction
		--get old sequence number
		--select @oldseq=Last_PSC_Serial_Seq from ProductLines
		--	where PSCGen_Station=@fcount and Top_Model_Prfx=@tname and Status='A'
		--if @@ERROR <>0
	   	--   begin
			--raiserror('E402.13 Undefined error. Unable to retrieve ProductLines db data.',17,1)
		--   	return 14
	   	--   end
		--Save new assemblies db record
		Update assemblies
		set PSC_Serial = @pserial
		where ACS_Serial = @aserial
		if @@ERROR <> 0
		   begin
			--raiserror('E402.14 Serious Error. Failed to update record in assemblies db',17,1)
			Rollback Transaction
			return 15
		   end
		--update ProductLines db record (make sure our value is greater than the old value
		--if @pseq>=@oldseq
		--   begin
			--Update ProductLines
			--set Last_PSC_Serial_Seq = @pseq
			--where Top_Model_Prfx=@tname and PSCGen_Station=@fcount and Status ='A'
			--if @@ERROR <> 0
		   	--begin
				--raiserror('E402.15 Serious Error. Failed to modify record in ProductLines db',17,1)
				--Rollback Transaction
				--return 16
		   	--end
		--   end

	--Commit T-SQL transaction
	Commit Transaction
	return 1
-- Create the Stored Procedure
GO