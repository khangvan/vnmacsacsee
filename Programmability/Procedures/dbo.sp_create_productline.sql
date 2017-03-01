SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_create_productline]
-- Define input parameters
	@tname 	char(5) = NULL, -- Top_Model_No prefix
	@pscid char(2) = NULL,  -- PSC_Serial_ID
	@pname char(10) = NULL,	-- Product_Name
	@fname char(20) = NULL, -- Finish Station name (use Stations db to obtain Finish_Station)
	@pscseq int = 0,	-- Last_PSC_Serial_Seq (last psc serial number sequence)
	@status	char(1) = 'A' 	-- Status
	
-- Define code
AS
	-- Define Local variables
	declare @fcount	int
	set @fcount = NULL -- Station_Count of finish station

	--Verify that non-NULLable parameter(s) have values
	if @tname is NULL
	   begin
		raiserror ('E301.1 Illegal Parameter Value. You must specify a Top Model Number Prefix.',
			16,1) with nowait
		return
	   end
	if @pscid is NULL
	   begin
		raiserror ('E301.2 Illegal Parameter Value. You must specify a PSC Serial ID (99 for Subassembly).',
			16,1) with nowait
		return
	   end
	if @pname is NULL
	   begin
		raiserror ('E301.3 Illegal Parameter Value. You must specify a product line name for reports.',
			16,1) with nowait
		return
	   end
	if @fname is NULL
	   begin
		raiserror ('E301.4 Illegal Parameter Value. You must specify a Finish Station Name.',
			16,1) with nowait
		return
	   end


	--See if Productline already exists
	if exists(select Status from ProductLines 
		where Top_Model_Prfx=@tname and Status='A')
	   begin
		raiserror ('E301.5 Illegal Parameter Value. Active Top Model Prefix %s already exists.',
			16,1,@tname) with nowait
		return
	   end

	--See if psc serial id already exists
	--if exists(select Status from ProductLines 
	--	where PSC_Serial_ID=@pscid and Status='A')
	--   begin
	--	raiserror ('E301.6 Illegal Parameter Value. Active PSC Serial ID %s already exists.',
	--		16,1,@pscid) with nowait
	--	return
	--  end
	
	--See if finish station exists
	if not exists(select Status from Stations 
		where Station_Name=@fname and Status='A')
	   begin
		raiserror ('E301.7 Illegal Parameter Value. Active Station %s does not exist.',
			16,1,@fname) with nowait
		return
	   end
	select @fcount=Station_Count from Stations
		where Station_Name=@fname and Status='A'
	if @@ERROR <> 0
		   Begin
			raiserror('E301.8 Serious error. Failed to get data from Stations db',17,1)
			Return
		   End

	--See if station is enabled to be a finish station
	if not exists(select Status from Stations 
		where Station_Count=@fcount and Gen_PSC_Serial='Y')
	   begin
		raiserror ('E301.9 Illegal Parameter Value. Active Station %s can not generate PSC serial numbers. Use sp_modify_station.',
			16,1,@fname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction
		-- Save record to Products db
		Insert ProductLines
		Values (@tname, @pscid, @pname, @pscseq, @fcount, @status,1,1)
		if @@ERROR <> 0
		   Begin
			raiserror('E301.10 Serious error. Failed to append to ProductLines db',17,1)
			Rollback Transaction
			Return
		   End
	
	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure

GO