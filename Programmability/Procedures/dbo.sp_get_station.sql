SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_get_station]
-- Define input parameters
	@sname 		char(20) = NULL, 	-- Station_Name
	@desc 		nchar(40) OUTPUT, 	-- Description
	@acsserial 	char(2) OUTPUT,	 	-- ACS_Serial_ID
	@genpsc 	char(1) OUTPUT,		-- Gen_PSC_Serial
	@asmprint 	char(1) OUTPUT,  	-- Print_Asm_Label
	@unitprint	char(1) OUTPUT,		-- Print_Unit_Label
	@cartonprint	char(1) OUTPUT,	 	-- Print_Carton_Label
	@extraprint	char(1) OUTPUT,		-- Print_Extra_Label
	@overrides	char(1) OUTPUT,	 	-- Allow_Overrides
	@fin		char(1) OUTPUT,		-- Finish_Assembly
	@test		char(1) OUTPUT,		-- Perform_Test 
	@assign		char(1) OUTPUT,		-- Assign_Sales_Order
	@back		char(1) OUTPUT, 	-- Backflush
	@status		char(1) OUTPUT,		-- Status
	@machine	char(30) OUTPUT		-- Machine Name (from the station's registry)

-- Define code
AS
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E5.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end

	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname)
	   begin
		raiserror ('E5.2 Illegal Parameter Value. Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end

	-- Get Station information exists
	-- Note: if you modify this, you must also modify [13] sp_get_station_record
	select  @desc=Description, @acsserial=ACS_Serial_ID,
		@genpsc=Gen_PSC_Serial, @asmprint=Print_Asm_Label, @unitprint=Print_Unit_Label,
		@cartonprint=Print_Carton_Label, @extraprint=Print_Extra_Label,
		@overrides=Allow_Overrides, @fin=Finish_Assembly, @test=Perform_Test,
		@assign=Assign_Sales_Order, @back=Backflush, @status=Status,
		@machine=Machine_Name from Stations
	where Station_Name=@sname
	if @@ERROR <>0
	   begin
		raiserror('E5.3 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end

-- Create the Stored Procedure


GO