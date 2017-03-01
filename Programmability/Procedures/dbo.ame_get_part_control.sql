SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create proc [dbo].[ame_get_part_control]
-- Define input parameters
	@sname 		char(20) = NULL
-- Define code
AS
	--Define local variable(s)
	declare @scount int
	set @scount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E106.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		raiserror ('E106.2 Illegal Parameter Value. Active station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E106.3 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end
	-- Create output cursor
	select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount
		order by Partlist.Disp_Order
	
-- Create the Stored Procedure



GO