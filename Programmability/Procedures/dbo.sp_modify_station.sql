SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_modify_station]
-- Define input parameters
	@sname 		char(20) = NULL,	-- Station_Name
	@ndesc 		nchar(40) = NULL, 	-- Description
	@nacsserial 	char(2) = NULL,		-- ACS_Serial_ID	 
	@ngenpsc 	char(1) = NULL,		-- Gen_PSC_Serial
	@nasmprint 	char(1) = NULL,	 	-- Print_Asm_Label
	@nunitprint	char(1) = NULL,		-- Print_Unit_Label
	@ncartonprint	char(1) = NULL,	 	-- Print_Carton_Label
	@nextraprint	char(1) = NULL,		-- Print_Extra_Label
	@noverrides	char(1) = NULL,		-- Allow_Overrides 
	@nfin		char(1) = NULL,		-- Finish_Assembly
	@ntest		char(1) = NULL, 	-- Perform_Test
	@nassign	char(1) = NULL,		-- Assign_Sales_Order
	@nback		char(1) = NULL,  	-- Backflush
	@nmachine	char(30) = NULL		-- Machine Name (from the station's registry)
	-- must use other stored proceedures to modify Status field
	
-- Define code
AS
	-- Define Local variables
	declare @acsserial char(2), @desc nchar(40), @genpsc char(1)
	declare @asmprint char(1), @unitprint char(1), @cartonprint char(1)
	declare @extraprint char(1), @overrides char(1), @fin char(1)
	declare @test char(1), @assign char(1), @back char(1)
	declare @status char(1), @scount int
	declare @machine char(30)
	
	set @scount = NULL -- Station_Count of station
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E4.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname)
	   begin
		raiserror ('E4.2 Illegal Parameter Value. Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	-- Begin transaction
	Begin Transaction

		-- Read in existing values
		exec sp_get_station @sname, @desc OUTPUT, @acsserial OUTPUT, @genpsc OUTPUT,
			@asmprint OUTPUT, @unitprint OUTPUT, @cartonprint OUTPUT, 
			@extraprint OUTPUT, @overrides OUTPUT, @fin OUTPUT,
			@test OUTPUT, @assign OUTPUT, @back OUTPUT, @status OUTPUT,
			@machine OUTPUT
		if @@ERROR <> 0
	   	   begin
			set @scount = NULL -- Will be NULL if modification failes
			raiserror ('E4.3 Read Error. Unable to sp_get_station.',17,1)
			rollback transaction
		   end

		-- Modify non-nulls
		if @ndesc is not null
		   begin
			set @desc = @ndesc
		   end
		if @nacsserial is not null
		   begin
			set @acsserial = @nacsserial
		   end
		if @ngenpsc is not null
		   begin
			set @genpsc = @ngenpsc
		   end
		if @nasmprint is not null
		   begin
			set @asmprint = @nasmprint
		   end
		if @nunitprint is not null
		   begin
			set @unitprint = @nunitprint
		   end
		if @ncartonprint is not null
		   begin
			set @cartonprint = @ncartonprint
		   end
		if @nextraprint is not null
		   begin
			set @extraprint = @nextraprint
		   end
		if @noverrides is not null
		   begin
			set @overrides = @noverrides
		   end
		if @nfin is not null
		   begin
			set @fin = @nfin
		   end
		if @ntest is not null
		   begin
			set @test = @ntest
		   end
		if @nassign is not null
		   begin
			set @assign = @nassign
		   end
		if @nback is not null
		   begin
			set @back = @nback
		   end
		if @nmachine is not null
		   begin
			set @machine = @nmachine
		   end


		-- Update Stations db record !!!!
		update Stations -- Note that Status does not get update here!
		SET Description=@desc, ACS_Serial_ID=@acsserial, Gen_PSC_Serial=@genpsc,
			Print_Asm_Label=@asmprint, Print_Unit_Label=@unitprint,
			Print_Carton_Label=@cartonprint, Print_Extra_Label=@extraprint,
			Allow_Overrides=@overrides, Finish_Assembly=@fin,
			Perform_Test=@test, Assign_Sales_Order=@assign, Backflush=@back,
			Machine_Name=@machine			
		where Station_Name=@sname
		if @@ERROR <> 0
	   	   begin
			set @scount = NULL -- Will be NULL if modification failes
			raiserror ('E4.4 Update Error. Unable to update Stations db record.',17,1)
			rollback transaction
		   end

	--Commit T-SQL Transaction

	Commit Transaction
-- Create the Stored Procedure


GO