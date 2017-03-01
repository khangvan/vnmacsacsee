SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create proc [dbo].[ame_get_station_record]
-- Define input parameters
	@sname 		char(20) = NULL 	-- Station_Name

-- Define code
AS
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E13.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end

	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname)
	   begin
		raiserror ('E13.2 Illegal Parameter Value. Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end

	-- Get Station information 
	-- Note: if you modify this, you must also modify [5] sp_get_station
	select Description,ACS_Serial_ID,Gen_PSC_Serial,Print_Asm_Label,Print_Unit_Label,
		Print_Carton_Label,Print_Extra_label,Allow_Overrides,Finish_Assembly,
		Perform_Test,Assign_Sales_Order,Backflush,Status,
		Machine_Name from Stations
	where Station_Name=@sname
	if @@ERROR <>0
	   begin
		raiserror('E13.3 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end
	
-- Create the Stored Procedure



GO