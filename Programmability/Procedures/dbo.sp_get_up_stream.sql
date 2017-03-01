SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_get_up_stream]
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
		raiserror ('E8.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		raiserror ('E8.2 Illegal Parameter Value. Active station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E8.3 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end
	-- Create output cursor
	select Station_Name, Machine_Name from Stations Inner join Lines
		on Stations.Station_Count=Lines.Station
		where Lines.Next_Station=@scount
-- Create the Stored Procedure


GO