SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


CREATE proc [dbo].[sp_create_line]
-- Define input parameters
	@sname 		char(20) = NULL, @nname		char(20) = NULL
-- Define code
AS
	--Define local variable(s)
	declare @scount int
	set @scount = NULL
	declare @ncount int
	set @ncount = NULL
	
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E10.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	if @nname is NULL
	   begin
		raiserror ('E10.2 Illegal Parameter Value. You must specify a desitination station name.',
			16,1) with nowait
		return
	   end
	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		raiserror ('E10.3 Illegal Parameter Value. Active station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E10.4 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end

	--See if Next Station exists
	if @nname is not NULL
	   begin
		if not exists(select Status from Stations 
			where Station_Name=@nname and Status='A')
	   	   begin
			raiserror ('E10.5 Illegal Parameter Value. Active station %s does not exist.',
				16,1,@nname) with nowait
			return
	   	   end
		select @ncount=Station_Count from Stations
			where Station_Name=@nname and Status='A'
		if @@ERROR <>0
	   	   begin
			raiserror('E10.6 Undefined error. Unable to retrieve Station db data.',17,1)
			return
	   	   end
		--if @ncount=@scount --make sure we're not talking to ourselves
		  -- begin
			--raiserror('E10.7 Illegal Parameter Value. Next station can not be the same as current station.',16,1)
			--return
		   --end
	   end			
	--See if Line with these parameters already exists
	if exists(select Station from Lines
		where Station=@scount and Next_Station=@ncount)
	   begin
		raiserror('E10.8 Insert error. Line already exists in Lines db.',16,1)
		return
	   end
	--Begin T-SQL Transaction
	Begin Transaction
		--Save new Lines db record
		Insert Lines
		Values(@scount, @ncount,256,256)
		if @@ERROR <> 0
		   begin
			raiserror('E10.9 Serious Error. Failed to append record to lines db',17,1)
			Rollback Transaction
			return
		   end
	--Commit T-SQL transaction
	Commit Transaction
-- Create the Stored Procedure
GO