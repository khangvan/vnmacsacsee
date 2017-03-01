SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_create_acs_serial]
-- Define input parameters
	@sname 		char(20) = NULL, -- Start Station Name
	@tname	char(5) = NULL,	-- Top_Model_No Prefix
	@lseq	int = 0, 	-- Last_ACS_Serial_Seq
	@ldate	datetime = NULL -- Ass_Date

-- Define code
AS
	--Define local variable(s)
	declare @scount int
	set @scount = NULL
	
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E307.1 Illegal Parameter Value. You must specify a Start Station Name.',
			16,1) with nowait
		return
	   end
	if @tname is NULL
	   begin
		raiserror ('E307.2 Illegal Parameter Value. You must specify a Top Model Number Prefix.',
			16,1) with nowait
		return
	   end
	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		raiserror ('E307.3 Illegal Parameter Value. Active Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	--See if Station is a 'start station'
	if exists(select Status from Stations 
		where Station_Name=@sname and Status='A' and (ACS_Serial_ID is NULL))
	   begin
		raiserror ('E307.4 Illegal Parameter Value. Active Station %s is not a start station.',
			16,1,@sname) with nowait
		return
	   end
	if exists(select Status from Stations 
		where Station_Name=@sname and Status='A' and ACS_Serial_ID='')
	   begin
		raiserror ('E307.5 Illegal Parameter Value. Active Station %s is not a start station.',
			16,1,@sname) with nowait
		return
	   end

	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E307.6 Undefined error. Unable to retrieve Stations db data.',17,1)
		return
	   end
	--See if Top Model exists
	if not exists(select Status from ProductLines 
		where Top_Model_Prfx=@tname and Status='A')
	   begin
		raiserror ('E307.7 Illegal Parameter Value. Active Top Model Prefix %s does not exist.',
			16,1,@tname) with nowait
		return
	   end

	--See if ACSSerialNumbers db record for this Top Model Number and this Station already exists
	if exists(select Last_ACS_Serial_Seq from ACSSerialNumbers
		where Start_Station=@scount and Top_Model_Prfx=@tname)
	   begin
		raiserror('E307.8 Insert error. ACS Serial record already exists for this Top Model Number Prefix and Start Station.',16,1)
		return
	   end
	--Begin T-SQL Transaction
	Begin Transaction
		--Save new ACSSerialNumbers db record
		Insert ACSSerialNumbers
		Values(@scount, @tname, @lseq, @ldate)

		if @@ERROR <> 0
		   begin
			raiserror('E307.9 Serious Error. Failed to append record to ACSSerialNumbers db',17,1)
			Rollback Transaction
			return
		   end
	--Commit T-SQL transaction
	Commit Transaction
-- Create the Stored Procedure


GO