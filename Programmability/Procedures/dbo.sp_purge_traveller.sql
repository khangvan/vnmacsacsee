SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_purge_traveller]
-- Define input parameters
	@aserial 		char(20) = NULL
-- Define code
AS
	
	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		raiserror ('E414.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			16,1) with nowait
		return
	   end

	--See if Assembly exists
	if not exists(select Start_Station from assemblies 
		where ACS_Serial=@aserial)
	   begin
		raiserror ('E414.2 Illegal Parameter Value. Assembly %s does not exist.',
			16,1,@aserial) with nowait
		return
	   end
	--Begin T-SQL Transaction
	Begin Transaction
		--Remove specific Travellers db record(s)
		Delete from Travellers
		where ACS_Serial=@aserial
		if @@ERROR <> 0
		   begin
			raiserror('E414.3 Serious Error. Failed to delete record in Travellers db',17,1)
			Rollback Transaction
			return
		   end
	--Commit T-SQL transaction
	Commit Transaction
-- Create the Stored Procedure


GO