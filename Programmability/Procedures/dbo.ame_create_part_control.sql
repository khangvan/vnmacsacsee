SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE proc [dbo].[ame_create_part_control]
-- Define input parameters
	@pname 		char(20) = NULL, @sname	char(20) = NULL,
	@menu		char(1) = NULL,  @auto	char(1) = NULL,
	@gets		char(1) = NULL,  @dispo int = 1,
	@fillq		int = 1
-- Define code
AS
	--Define local variable(s)
	declare @comment varchar(20)
	declare @pcount int
	set @pcount = NULL
	declare @scount int
	set @scount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @pname is NULL
	   begin
		raiserror(50011,10,1,'1.0701','Part Number')		
/*raiserror ('E107.1 Illegal Parameter Value. You must specify a part name.',*/
/*			16,1) with nowait*/
		return
	   end
	if @sname is NULL
	   begin
		raiserror(50011,10,1,'1.0702','Station Name')		
/*		raiserror ('E107.2 Illegal Parameter Value. You must specify a station name.',*/
/*			16,1) with nowait*/
		return
	   end
	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		set @comment = ltrim(rtrim(@sname))
		raiserror(50017,10,1,'1.0703',@comment)
		/*raiserror ('E107.3 Illegal Parameter Value. Active station %s does not exist.',*/
/*			16,1,@sname) with nowait*/
		return
	   end
	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror(50013,10,1,'1.0704','Station Table read Failure')
/*		raiserror('E107.4 Undefined error. Unable to retrieve Station db data.',17,1)*/
		return
	   end

	--See if part exists
	if @pname is not NULL
	   begin
		if not exists(select Status from Catalog 
			where Part_No_Name=@pname and Status='A')
	   	   begin
			set @comment = ltrim(rtrim(@pname))
			raiserror(50017,10,1,'1.0705',@comment)
			/*raiserror ('E107.5 Illegal Parameter Value. Active part %s does not exist.',*/
/*				16,1,@pname) with nowait*/
			return
	   	   end
		select @pcount=Part_No_Count from Catalog
			where Part_No_Name=@pname and Status='A'
		if @@ERROR <>0
	   	   begin
			raiserror(50013,10,1,'1.0706','Station Table read Failure')
	/*raiserror('E107.6 Undefined error. Unable to retrieve Catalog db data.',17,1)*/
			return
	   	   end
	   end			
	--See if Partlist for this part at this station already exists <--deleted 1/30/02
/*	if exists(select Part_No from Partlist
		where Part_No=@pcount and Station=@scount)
	   begin
		raiserror('E107.7 Insert error. Part Control already exists for this part at this station.',16,1)
		return --jmm
	   end
*/
	--Begin T-SQL Transaction
	Begin Transaction
		--Save new Partlist db record
		Insert Partlist
		Values(@pcount, @scount,@menu, @auto, @gets,@dispo,@fillq)
		if @@ERROR <> 0
		   begin
			raiserror('E107.8 Serious Error. Failed to append record to Partlist db',17,1)
			Rollback Transaction
			return
		   end
	--Commit T-SQL transaction
	Commit Transaction
-- Create the Stored Procedure
GO