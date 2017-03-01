SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_purge_line]
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
		raiserror ('E11.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	if @nname is NULL
	   begin
		raiserror ('E11.2 Illegal Parameter Value. You must specify a desitination station name.',
			16,1) with nowait
		return
	   end

	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		raiserror ('E11.3 Illegal Parameter Value. Active station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E11.4 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end

	--See if Next Station exists
	if @nname is not NULL
	   begin
		if not exists(select Status from Stations 
			where Station_Name=@nname and Status='A')
	   	   begin
			raiserror ('E11.5 Illegal Parameter Value. Active station %s does not exist.',
				16,1,@nname) with nowait
			return
	   	   end
		select @ncount=Station_Count from Stations
			where Station_Name=@nname and Status='A'
		if @@ERROR <>0
	   	   begin
			raiserror('E11.6 Undefined error. Unable to retrieve Station db data.',17,1)
			return
	   	   end
		if @ncount=@scount --make sure we're not talking to ourselves
		   begin
			raiserror('E11.7 Illegal Parameter Value. Next station can not be the same as current station.',16,1)
			return
		   end
	   end			
	--Begin T-SQL Transaction
	Begin Transaction
		--Remove specific Lines db record(s)
		Delete from Lines
		where Station=@scount and Next_Station=@ncount
		if @@ERROR <> 0
		   begin
			raiserror('E11.8 Serious Error. Failed to delete record in lines db',17,1)
			Rollback Transaction
			return
		   end
	--Commit T-SQL transaction
	Commit Transaction
-- Create the Stored Procedure


GO