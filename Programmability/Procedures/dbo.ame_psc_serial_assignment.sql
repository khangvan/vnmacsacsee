SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


CREATE proc [dbo].[ame_psc_serial_assignment]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@pserial	char(20) = NULL -- PSC_Serial
	--@fname		char(20) = NULL -- Finish_Station (get scount from Stations db)
	--@tname		char(5) = NULL, -- Top_Model_No (ProductLines db)
	--@pseq		int = NULL	-- Last_PSC_Serial_Seq (ProductLines db)-- Define code
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
	--See if ACS Serial Number exists
	if not exists(select Start_Station from assemblies 
		where ACS_Serial=@aserial)
	   begin
		--raiserror ('E402.6 Illegal Parameter Value. ACS Serial Number %s does not exist.',
			--16,1,@aserial) with nowait
--changed on 7/16/04 from 7 for db change
		return 1
	   end
	--See if PSC Serial Number already exists
	if exists(select Start_Station from assemblies 
		where PSC_Serial=@pserial)
	   begin
		--raiserror ('E402.7 Illegal Parameter Value. PSC Serial Number %s already exits.',
			--16,1,@pserial) with nowait
		return 1
	   end
	
	--Begin T-SQL Transaction
	set LOCK_TIMEOUT 2000 -- wait upto 2 seconds for locked records to free up
	set transaction isolation level repeatable read --lock the db records!
	Begin Transaction
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

	--Commit T-SQL transaction
	Commit Transaction
	return 1
-- Create the Stored Procedure
GO