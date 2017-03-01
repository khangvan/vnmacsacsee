SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE proc [dbo].[ame_exit_ort]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@sname		char(20) = NULL, -- Station_Name (from Stations db)
	@testid		char(50) = NULL, -- Scanned component serial number
	@strval		char(20) = NULL -- Scanned component serial number
	
-- Define code
AS
declare @origaserial char(20)
declare @netproserial char(20)
	declare @tdate datetime
	set @tdate = getdate()

	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		--raiserror ('E403.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			--16,1) with nowait
		return 2
	   end
/*
set @origaserial = @aserial
if exists (select Tffc_Serialnumber from tffc_serialnumbers
where tffc_reservedby=@aserial )
begin
   select @netproserial =  Tffc_Serialnumber from tffc_serialnumbers
where tffc_reservedby=@aserial

if ( len(rtrim(@netproserial)) > 0 )
begin
set @aserial = @netproserial
end
end
*/
	Begin Transaction
		--Save new testlog db record
		Insert testlog ( ACS_Serial, SAP_Model, Station, Test_ID, Pass_Fail, FirstRun, Test_Date_Time, ACSEEMode)
		Values(@aserial, 'EXITORT', @sname, @testid, 'P', ' ',
			@tdate,0)
		if @@ERROR <> 0
		   begin
			--raiserror('E403.13 Serious Error. Failed to append record to assemblies db',17,1)
			Rollback Transaction
			return 12
		   end
		--Save new subtestlog db record
		Insert subtestlog (ACS_Serial, Station, SubTest_Name, Test_ID, Pass_Fail, strValue, intValue, floatValue, Units, Comment)
		Values(@aserial, @sname, 'EXITORT', @testid, 'P', ' ',
			0,0.0,' ',@strval)
		if @@ERROR <> 0
		   begin
			--raiserror('E403.13 Serious Error. Failed to append record to assemblies db',17,1)
			Rollback Transaction
			return 12
		   end

		--Save new assemblies db record
		Update assemblies
		set Current_State='P'
		where ACS_Serial = @origaserial
		if @@ERROR <> 0
		   begin
			--raiserror('E402.14 Serious Error. Failed to update record in assemblies db',17,1)
			Rollback Transaction
			return 15
		   end
		-- ORTVault
		Delete ORTVault 
		where acs_serial=@aserial
		if @@ERROR <> 0
		   begin
			--raiserror('E403.13 Serious Error. Failed to append record to assemblies db',17,1)
			Rollback Transaction
			return 12
		   end


	--Commit T-SQL transaction
	Commit Transaction
	return 1
-- Create the Stored Procedure
GO