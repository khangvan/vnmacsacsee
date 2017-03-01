SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_modify_part_control]
-- Define input parameters
	@pname		char(20) = NULL,	-- Part_No_Name
	@sname 		char(20) = NULL,	-- Station_Name
	@nmenun 	char(1) = NULL,		-- Menu_Name 
	@nautom		char(1) = NULL,		-- Automatic fill
	@ngetsn 	char(1) = NULL,	 	-- Get sub-assembly serial number
	@ndispord	int = -1,		-- Display Order
	@nfillquan	int = -1			-- Fill Quantity
		
-- Define code
AS
	-- Define Local variables
	declare @menun char(1), @autom char(1), @getsn char(1)
	declare @dispord int, @fillquan int
	declare @scount int, @pcount int
	
	set @scount = NULL -- Station_Count of station
	set @pcount = NULL -- Part_No_Count

	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E116.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	if @pname is NULL
	   begin
		raiserror ('E116.2 Illegal Parameter Value. You must specify a part name.',
			16,1) with nowait
		return
	   end
	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname)
	   begin
		raiserror ('E116.3 Illegal Parameter Value. Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	select @scount = Station_Count from Stations
		where Station_Name=@sname
	--See if Part exists
	if not exists(select Status from Catalog 
		where Part_No_Name=@pname)
	   begin
		raiserror ('E116.4 Illegal Parameter Value. Part %s does not exist.',
			16,1,@pname) with nowait
		return
	   end
	select @pcount = Part_No_Count from Catalog
		where Part_No_Name=@pname
	--See if part is controlled at this station
	if not exists(select Get_Serial from Partlist 
		where Part_No = @pcount and Station = @scount)
	   begin
		raiserror ('E116.5 Illegal Parameter Value. Part is not controlled at Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end

	-- Begin transaction
	Begin Transaction

		-- Read in existing values
		exec sp_get_part_control_arg @sname, @pname, @menun OUTPUT, @autom OUTPUT, @getsn OUTPUT,
			@dispord OUTPUT, @fillquan OUTPUT
		if @@ERROR <> 0
	   	   begin
			set @scount = NULL -- Will be NULL if modification failes
			set @pcount = NULL
			raiserror ('E116.6 Read Error. Unable to sp_get_part_control_arg.',17,1)
			rollback transaction
		   end

		-- Modify non-nulls
		if @nmenun is not null
		   begin
			set @menun = @nmenun
		   end
		if @nautom is not null
		   begin
			set @autom = @nautom
		   end
		if @ngetsn is not null
		   begin
			set @getsn = @ngetsn
		   end
		if @ndispord <> -1
		   begin
			set @dispord = @ndispord
		   end
		if @nfillquan <> -1
		   begin
			set @fillquan = @nfillquan
		   end
	
		-- Update Partlist db record !!!!
		update Partlist
		SET Menu=@menun, Automatic=@autom, Get_Serial=@getsn,
			Disp_Order=@dispord, Fill_Quantity=@fillquan
		where Part_No=@pcount and Station = @scount
		if @@ERROR <> 0
	   	   begin
			set @scount = NULL -- Will be NULL if modification failes
			set @pcount = NULL
			raiserror ('E116.7 Update Error. Unable to update Partlist db record.',17,1)
			rollback transaction
		   end

	--Commit T-SQL Transaction

	Commit Transaction
-- Create the Stored Procedure


GO