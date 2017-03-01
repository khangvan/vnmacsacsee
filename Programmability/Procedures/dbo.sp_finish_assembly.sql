SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



CREATE proc [dbo].[sp_finish_assembly]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@fname		char(20) = NULL,
	@edate		datetime = NULL
-- Define code
AS

	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		--raiserror ('E408.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			--16,1) with nowait
		return 2
	   end
	if @fname is NULL
	   begin
		--raiserror ('E408.2 Illegal Parameter Value. You must specify a finish station.',
			--16,1) with nowait
		return 3
	   end
	if @edate is NULL
	   begin
		--raiserror ('E408.3 Illegal Parameter Value. You must specify an end datetime.',
			--16,1) with nowait
		return 4
	   end

	--See if ACS Serial Number exists
	if not exists(select Start_Station from assemblies 
		where ACS_Serial=@aserial)
	   begin
		--raiserror ('E408.4 Illegal Parameter Value. ACS Serial Number %s does not exist.',
			--16,1,@aserial) with nowait
		return 5
	   end
	--See if finish station exists
	if not exists(select Station_Count from Stations 
		where Station_Name=@fname and Status='A' and Finish_Assembly='Y')
	   begin
		--raiserror ('E408.5 Illegal Parameter Value. Finish Station %s does not exist.',
		--	16,1,@fname) with nowait
		return 6
	   end

	--Begin T-SQL Transaction
	set LOCK_TIMEOUT 2000 -- wait upto 2 seconds for locked records to free up
	set transaction isolation level repeatable read --lock the db records!
	Begin Transaction
		--Update assemblies db record (lock assemblies db)
		Update assemblies
		set End_Mfg = @edate
		where ACS_Serial = @aserial
		if @@ERROR <> 0
		   begin
			--raiserror('E408.6 Serious Error. Failed to update record in assemblies db',17,1)
			Rollback Transaction
			return 7
		   end
	
	--Commit T-SQL transaction
	Commit Transaction
	return 1
-- Create the Stored Procedure
GO