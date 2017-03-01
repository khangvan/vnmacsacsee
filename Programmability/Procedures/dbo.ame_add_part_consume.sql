SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE proc [dbo].[ame_add_part_consume]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@pname		char(20) = NULL, -- Part_No_Name (in Catalog db)
	@sname		char(20) = NULL, -- Station_Name (from Stations db)
--	@adate		datetime = NULL, -- date filled
--	@qadded		int = 1, 	-- Quanitity_Filled
	@sserial	char(20) = NULL, -- Scanned component serial number
	@rev		char(2) = NULL -- Rev (version)
	
-- Define code
AS
	--Define local variable(s)
	declare @adate datetime
	set @adate = getdate()
	declare @scount int -- station
	set @scount = NULL
	declare @pcount int -- part
	set @pcount = NULL
	declare @oldq int
	set @oldq = 0
	declare @newfilled int
	set @newfilled = 0
	declare @nextstn char(20)
	
	
	
insert into  ADDPART_Log
(
ADDPARTLOG_Action, ADDPARTLOG_TOPSerial, ADDPARTLOG_BottomSerial, 
ADDPARTLOG_Part, ADDPARTLOG_Note, ADDPARTLOG_DateTime
)
values
(
'Entered add_part',@aserial,@sserial,
@pname,@sname,GETDATE()
)
	
	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		--raiserror ('E403.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			--16,1) with nowait
		return 2
	   end
	if @pname is NULL
	   begin
		--raiserror ('E403.2 Illegal Parameter Value. You must specify a Part Number Name.',
			--16,1) with nowait
		return 3
	   end
	if @sname is NULL
	   begin
		--raiserror ('E403.4 Illegal Parameter Value. You must specify a station name.',
			--16,1) with nowait
		return 4
	   end

	--See if part exists
	if not exists(select Part_No_Count from Catalog with(NOLOCK)
		where Part_No_Name=@pname and Status='A')
	   begin
		-- create part
		exec ame_create_part @pname
	   end
	select @pcount=Part_No_Count from Catalog with(NOLOCK)
		where Part_No_Name=@pname and Status='A'
	if @@ERROR <>0
	   begin
		--raiserror('E403.8 Undefined error. Unable to retrieve Catalog db data.',17,1)
		return 8
	   end
	--See if station exists
	if not exists(select Station_Count from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		--raiserror ('E403.9 Illegal Parameter Value. Active Station %s does not exist.',
			--16,1,@sname) with nowait
		return 9
	   end
	   
	   
insert into  ADDPART_Log
(
ADDPARTLOG_Action, ADDPARTLOG_TOPSerial, ADDPARTLOG_BottomSerial, 
ADDPARTLOG_Part, ADDPARTLOG_Note, ADDPARTLOG_DateTime
)
values
(
'At 10 in add_part',@aserial,@sserial,
@pname,@sname,GETDATE()
)	   
	select @scount=Station_Count from Stations with(NOLOCK)
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		--raiserror('E403.10 Undefined error. Unable to retrieve Station db data.',17,1)
		return 10
	   end
	-- See if this station is setup to control this part
	--if not exists(select Fill_Quantity from Partlist 
	--	where Part_No=@pcount and Station=@scount)
	 --  begin
		--raiserror ('E403.11 Illegal Parameter Value. Part is not controlled at this station.',
			--16,1) with nowait
		--return 11
	   --end
	-- Get old quantity filled value
--	select @oldq = Quantity_Filled from Travellers
--		where ACS_Serial=@aserial and Part_No=@pcount
--	if @@ERROR <> 0
--	   begin
--		raiserror('E403.12 Serious Error. Failed to get data from travellers db',17,1)
--		return
--	   end
--	set @newfilled = @oldq + @qadded

	-- Insert into LociCoupled (print Option_5)
	if  (@pname like '0801-104%') or (@pname like '6301-000%')  or (@pname like '6106-000%') or (@pname like '6102-000%') or @pname = 'MACID' 
                 or @pname in ('8-0717-02', '8-0717-03','BASE','8-0775-01','HHScanner')
	  begin
		insert [ACSEEState].dbo.locicoupled
		Values(@aserial,@pname,@sserial)
	  end
	
	-- Verify Previous station validation for these parts. When these parts are built off shore they will have to be removed from this check.
	-- Did part pass at Mufasalensfocus?
	if (@sname = 'ACSLEOSTART') and (@pname in ('5-2441','5-2442-01','5-2442-02')) and (len(@sserial)>3)
	   begin
		select @nextstn=Next_Station_Name from  [ACSEEState].dbo.loci with(NOLOCK)
		where ACS_Serial=@sserial
		if( ltrim(@nextstn)<>'MUFASAPERFORMANCE1')
		   begin
			return 13
		   end
   	   end

/* 5-2441 added per R Person and L Smith request */
	if (@sname = 'ACSLEOSTART') and (@pname in ('3-0676-02','3-0676-04','3-0676-06')) and (len(@sserial)>3)
	   begin
		select @nextstn=Next_Station_Name from  [ACSEEState].dbo.loci  with(NOLOCK)
		where ACS_Serial=@sserial
		if( ltrim(@nextstn)<>'ACSLEOSTART')
		   begin
			return 13
		   end
   	   end

/* per R. Person and L. Smith request  */
if (@sname = 'ACSSIMSTART') and (@pname in ('5-2442','5-3109','5-3125')) and (len(@sserial)>3)
	   begin
		select @nextstn=Next_Station_Name from  [ACSEEState].dbo.loci with(NOLOCK)
		where ACS_Serial=@sserial
	/*	if( ltrim(@nextstn)<>'ACSSIMSTART') */
                           if ( ltrim(@nextstn) <> 'MUFASAPERFORMANCE1')
		   begin
			return 13
		   end
   	   end


-- Add for Rhino previous station validation
/*
           if ( @sname='ACSEEFULRCSTART' and  ( substring(@pname,1,3) = 'M22' OR  substring(@pname,1,3) = 'M23'))
             begin
		select @nextstn=Next_Station_Name from  [ACSEEState].dbo.loci
		where ACS_Serial=@sserial
		if( ltrim(@nextstn)<>'ACSEEFULRCSTART')
		   begin
			return 13
		   end

             end
*/

	if (@sname = 'ACSLEOSTART') and (@pname in ('3-0677-02','3-0677-04')) and (len(@sserial)>3)
	   begin
		select @nextstn=Next_Station_Name from  [ACSEEState].dbo.loci with(NOLOCK)
		where ACS_Serial=@sserial
		if( ltrim(@nextstn)<>'ACSLEOSTART')
		   begin
			return 13
		   end
   	   end

	-- Did part pass Hawkeye far focus?
	-- ...
insert into  ADDPART_Log
(
ADDPARTLOG_Action, ADDPARTLOG_TOPSerial, ADDPARTLOG_BottomSerial, 
ADDPARTLOG_Part, ADDPARTLOG_Note, ADDPARTLOG_DateTime
)
values
(
'begin transaction in add_part',@aserial,@sserial,
@pname,@sname,GETDATE()
)
	--Begin T-SQL Transaction
	Begin Transaction
		--Save new asylog db record
		Insert asylog (ACS_Serial, Station, action,added_part_no,scanned_serial,rev,action_date, quantity)
		Values(@aserial, @scount, 403, @pcount, @sserial, @rev, @adate, 1)
		if @@ERROR <> 0
		   begin
			--raiserror('E403.13 Serious Error. Failed to append record to assemblies db',17,1)
			Rollback Transaction
			return 12
		   end
		--Update Travellers db
--		update Travellers
--		set Quantity_Filled = @newfilled
--		where ACS_Serial=@aserial and Part_No=@pcount
--		if @@ERROR <> 0
--		   begin
--			raiserror('E403.14 Serious Error. Failed to update record in travellers db',17,1)
--			Rollback Transaction
--			return
--		   end
	--Commit T-SQL transaction
	Commit Transaction
insert into  ADDPART_Log
(
ADDPARTLOG_Action, ADDPARTLOG_TOPSerial, ADDPARTLOG_BottomSerial, 
ADDPARTLOG_Part, ADDPARTLOG_Note, ADDPARTLOG_DateTime
)
values
(
'finished transact add_part',@aserial,@sserial,
@pname,@sname,GETDATE()
)	
	return 1
-- Create the Stored Procedure
GO