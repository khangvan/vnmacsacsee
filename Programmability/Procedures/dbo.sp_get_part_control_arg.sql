SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_get_part_control_arg]
-- Define input parameters
	@sname 		char(20) = NULL, -- Station Name
	@pname		char(20) = NULL, -- Part Name
	@menun		char(1) OUTPUT, -- Menu name
	@autom		char(1)	OUTPUT, -- Automatic fill
	@getsn		char(1) OUTPUT, -- Get part serial number
	@dispord	int	OUTPUT, -- Diplay Order
	@fillquan	int	OUTPUT  -- Fill Quantity
-- Define code
AS
	--Define local variable(s)
	declare @scount int
	set @scount = NULL
	declare @pcount int
	set @pcount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E113.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	if @pname is NULL
	   begin
		raiserror ('E113.2 Illegal Parameter Value. You must specify a part name.',
			16,1) with nowait
		return
	   end
	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		raiserror ('E113.3 Illegal Parameter Value. Active station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E113.4 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end
	--See if Part exists
	if not exists(select Status from Catalog 
		where Part_No_Name=@pname and Status='A')
	   begin
		raiserror ('E113.5 Illegal Parameter Value. Active part %s does not exist.',
			16,1,@pname) with nowait
		return
	   end
	select @pcount=Part_No_Count from Catalog
		where Part_No_Name=@pname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E113.6 Undefined error. Unable to retrieve part db data.',17,1)
		return
	   end
	-- Create output
	select @menun = Menu, @autom = Automatic, @getsn = Get_Serial, @dispord = Disp_Order,
		@fillquan = Fill_Quantity from Partlist where Station = @scount and Part_No = @pcount
	
-- Create the Stored Procedure


GO