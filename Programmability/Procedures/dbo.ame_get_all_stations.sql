SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE proc [dbo].[ame_get_all_stations]

-- Define code
AS
set nocount on
	Select Station_Name, Description,ACS_Serial_ID,Gen_PSC_Serial,Print_Asm_Label,
		Print_Unit_Label,Print_Carton_Label,Print_Extra_Label,Allow_Overrides,
		Finish_Assembly,Perform_Test,Assign_Sales_Order,Backflush,Status,
		Machine_Name from Stations
	order by Station_Name
	if @@ERROR <>0
	   begin
		raiserror('E12.1 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end

-- Create the Stored Procedure
GO