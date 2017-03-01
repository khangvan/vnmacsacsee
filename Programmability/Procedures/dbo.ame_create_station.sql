SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE proc [dbo].[ame_create_station]
-- Define input parameters
	@sname 		char(20) = NULL, -- Station_Name
	@desc 		nchar(40) = NULL, -- Description
	@acsserial 	char(2) = NULL,	 -- ACS_Serial_ID
	@genpsc 	char(1) = NULL, -- Gen_PSC_Serial
	@asmprint 	char(1) = NULL,	 -- Print_Asm_Label
	@unitprint	char(1) = NULL,	-- Print_Unit_Label
	@cartonprint	char(1) = NULL,	 -- Print_Carton_Label
	@extraprint	char(1) = NULL,	-- Print_Extra_Label
	@overrides	char(1) = NULL,	 -- Allow_Overrides
	@fin		char(1) = NULL,	-- Finish_Assembly 
	@test		char(1) = NULL, -- Perform_Test
 	@assign		char(1) = NULL, -- Assign_Sales_Order
	@back		char(1) = NULL,	-- Backflush (keep as NULL, included for future development) 
	@status		char(1) = 'A', -- Status
	@machine	char(30) = NULL, -- Machine Name (from the station's registry)
	@factory	int = 1,
	@Product	int = 1,
	@Order		int = 0,
	@Thin		char(1)='Y',
	@stype		char(3)='ACS',
	@Water	char(20)='ENGACSDB',
	@App		char(20)='ACSEEAPP1',
	@Bus		char(20)='ENGACSDB'
-- Define code
AS
	-- Define Local variables
	declare @scount	int
	set @scount = NULL -- Station_Count of new station

	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E1.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end

	--Make and NULL be the same for the ACS Serial ID
	--if @acsserial = ""
	  -- begin
		--set @acsserial = NULL
	   --end
	if  exists ( select station_count  from stations where Station_Name = @sname )
	  begin
		raiserror ('E1.2 Illegal Parameter Value. Station %s already exists.',
			16,1,@sname) with nowait
		return

               end

	--See if Station already exists
	if exists(select Status from Stations 
		where (Station_Name=@sname) and (Machine_Name=@machine))
	   begin
		raiserror ('E1.2 Illegal Parameter Value. Station %s already exists.',
			16,1,@sname) with nowait
		return
	   end
	-- See if Active station already exists with same ACS_Serial_ID
	
	if len(@acsserial)>0
	  begin
		if exists(select Status from Stations 
			where ACS_Serial_ID=@acsserial and Status='A')
	   	   begin
			raiserror ('E1.3 Illegal Parameter Value. Active station already exists with %s ACS Serial ID.',
				16,1,@acsserial) with nowait
			return
	   	   end
	  end
	--Begin T-SQL Transaction
	Begin transaction
		-- Increment Counter for Station_Count in the Counters db
		exec ame_get_next_counter '3',@scount OUTPUT -- Last_Station_Count
		if @scount is NULL
		   Begin
			raiserror('E1.4 Serious error. Failed to update Counters db',17,1)
			Rollback Transaction
			return
		   End

		-- Save record to Stations db
		Insert Stations ( Station_Count, Station_Name, Description, ACS_Serial_ID, Gen_PSC_Serial, 
                                                    Print_Asm_Label, Print_Unit_Label, Print_Carton_Label, Print_Extra_label, Allow_Overrides, 
                                                    Finish_Assembly, Perform_Test, Assign_Sales_Order, Backflush, Status, Machine_Name, 
                                                    FactoryGroup_Mask, ProductGroup_Mask, Order_Value, Thin_Client, Station_Type, 
                                                    Waterfall_Server_Machine_Name, Application_Server_Machine_Name, 
                                                    Business_Server_Machine_Name, STN_MfgLine_ID, SPCEnabled, SAPLocationIndex) 
		Values (@scount, @sname, @desc, @acsserial, @genpsc, @asmprint,
			@unitprint, @cartonprint, @extraprint, @overrides,
			@fin, @test, @assign, @back, @status, @machine,@factory,@product,@order,
			@Thin,@sType,@Water,@App,@Bus,1000,'N',0)
		if @@ERROR <> 0
		   Begin
			raiserror('E1.5 Serious error. Failed to append to Stations db',17,1)
			Rollback Transaction
			Return
		   End
	
	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure
GO