SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_change_part_number]
-- Define input parameters
	@aserial char(20) = NULL,	-- ACS_Serial
	@pname 	char(20) = NULL,	-- Old part name
	@nname 	char(20) = NULL		-- New part name
	
-- Define code
AS

	-- Define local variables
	declare @pcount int
	set @pcount = NULL
	declare @ncount int
	set @ncount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		raiserror ('E410.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			16,1) with nowait
		return
	   end
	if @pname is NULL
	   begin
		raiserror ('E410.2 Illegal Parameter Value. You must specify an old part name to replace.',
			16,1) with nowait
		return
	   end
	if @nname is NULL
	   begin
		raiserror ('E410.3 Illegal Parameter Value. You must specify a new part name.',
			16,1) with nowait
		return
	   end
	--See if old part exists
	if not exists(select Status from Catalog 
		where Part_No_Name=@pname and Status='A')
	   begin
		raiserror ('E410.4 Illegal Parameter Value. Part %s does not exist.',
			16,1,@pname) with nowait
		return
	   end
	select @pcount=Part_No_Count from Catalog
		where Part_No_Name=@pname and Status='A'
	if @@ERROR <> 0
   	   begin
		raiserror ('E410.4 Read Error. Unable to get Catalog db record.',17,1)
		return
	   end

	--See if new part exists
	if not exists(select Status from Catalog 
		where Part_No_Name=@nname and Status='A')
	   begin
		raiserror ('E410.5 Illegal Parameter Value. Part %s does not exist.',
			16,1,@nname) with nowait
		return
	   end
	select @ncount=Part_No_Count from Catalog
		where Part_No_Name=@nname and Status='A'
	if @@ERROR <> 0
   	   begin
		raiserror ('E410.6 Read Error. Unable to get Catalog db record.',17,1)
		return
	   end
	--See if assembly exists
	if not exists(select Start_Station from assemblies 
		where ACS_Serial=@aserial)
	   begin
		raiserror ('E410.7 Illegal Parameter Value. Assembly %s does not exist.',
			16,1,@aserial) with nowait
		return
	   end
	--See if travellers record exists
	if not exists(select Quantity_Required from travellers 
		where ACS_Serial=@aserial and Part_No=@pcount)
	   begin
		raiserror ('E410.8 Illegal Parameter Value. Traveller does not exist for this assembly with this part.',
			16,1) with nowait
		return
	   end


	-- Begin transaction
	Begin Transaction
		-- Update Catalog db record
		update Travellers
		SET Part_No=@ncount	
		where ACS_Serial=@aserial and Part_No=@pcount
		if @@ERROR <> 0
	   	   begin
			raiserror ('E410.9 Update Error. Unable to update Travellers db record.',17,1)
			rollback transaction
			return
		   end

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO