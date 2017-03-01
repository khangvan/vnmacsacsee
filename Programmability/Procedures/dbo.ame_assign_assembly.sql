SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


CREATE proc [dbo].[ame_assign_assembly]
-- Define input parameters
	@pserial	char(20) = NULL, -- PSC_Serial
	@sorder		char(10) = NULL, -- Sales order number
	@litem		char(6) = NULL, -- Line Item
	@sname		char(20) = NULL -- Assignment Station Name
	-- Define code
AS
	-- Local variables
	declare @psctest char(1)
	set @psctest=null

	--Verify that non-NULLable parameter(s) have values
	if @pserial is NULL
	   begin
		--raiserror ('E407.1 Illegal Parameter Value. You must specify an PSC Serial Number.',
			--16,1) with nowait
		return 2
	   end
	if @sorder is NULL
	   begin
		--raiserror ('E407.2 Illegal Parameter Value. You must specify a Sales Order.',
			--16,1) with nowait
		return 3
	   end
	if @litem is NULL
	   begin 
		--raiserror ('E407.3 Illegal Parameter Value. You must specify a Line Item.',
			--16,1) with nowait
		return 4
	   end
	if @sname is NULL
	   begin 
		--raiserror ('E407.4 Illegal Parameter Value. You must specify an assignment station name.',
			--16,1) with nowait
		return 5
	   end

	--See if PSC Serial Number exists
	if not exists(select Start_Station from assemblies 
		where PSC_Serial=@pserial)
	   begin
		--raiserror ('E407.5 Illegal Parameter Value. PSC Serial Number %s does not exist.',
			--16,1,@pserial) with nowait
--changed from 6 to 1 on 7/16/04
		return 1
	   end
	--See if Assignment Station exists
	if not exists(select Station_Count from Stations 
		where Station_Name=@sname and Status='A' and Assign_Sales_Order='Y')
	   begin
		--raiserror ('E407.6 Illegal Parameter Value. Active Assignment Station %s does not exist.',
			--16,1,@sname) with nowait
		return 7
	   end

	--Begin T-SQL Transaction
	set LOCK_TIMEOUT 2000 -- wait upto 2 seconds for locked records to free up
	set transaction isolation level repeatable read --lock the db records!
	Begin Transaction
		--Update assemblies db record (lock assemblies db)
		Update assemblies
		set Sales_Order = @sorder, Line_Item = @litem
		where PSC_Serial = @pserial
		if @@ERROR <> 0
		   begin
			--raiserror('E407.7 Serious Error. Failed to update record in assemblies db',17,1)
			Rollback Transaction
			return 8
		   end
	
	--Commit T-SQL transaction
	Commit Transaction
	return 1

-- Create the Stored Procedure
GO