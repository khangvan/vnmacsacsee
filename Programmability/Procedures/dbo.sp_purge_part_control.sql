SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_purge_part_control]
-- Define input parameters
	@pname 		char(20) = NULL, @sname		char(20) = NULL
-- Define code
AS
	--Define local variable(s)
	declare @pcount int
	set @pcount = NULL
	declare @scount int
	set @scount = NULL
	
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E108.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	if @pname is NULL
	   begin
		raiserror ('E108.2 Illegal Parameter Value. You must specify a part name.',
			16,1) with nowait
		return
	   end

	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		raiserror ('E108.3 Illegal Parameter Value. Active station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E108.4 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end

	--See if part exists
	if @pname is not NULL
	   begin
		if not exists(select Status from Catalog 
			where Part_No_Name=@pname and Status='A')
	   	   begin
			raiserror ('E108.5 Illegal Parameter Value. Active part %s does not exist.',
				16,1,@pname) with nowait
			return
	   	   end
		select @pcount=Part_No_Count from Catalog
			where Part_No_Name=@pname and Status='A'
		if @@ERROR <>0
	   	   begin
			raiserror('E108.6 Undefined error. Unable to retrieve Catalog db data.',17,1)
			return
	   	   end
	   end			
	--Begin T-SQL Transaction
	Begin Transaction
		--Remove specific Partlist db record(s)
		Delete from Partlist
		where Part_No=@pcount and Station=@scount
		if @@ERROR <> 0
		   begin
			raiserror('E108.7 Serious Error. Failed to delete record in Partlist db',17,1)
			Rollback Transaction
			return
		   end
	--Commit T-SQL transaction
	Commit Transaction
-- Create the Stored Procedure


GO