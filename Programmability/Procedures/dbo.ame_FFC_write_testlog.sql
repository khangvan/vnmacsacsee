SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_FFC_write_testlog]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@sap		char(20) = NULL,
	@sname		char(20) = NULL, -- Station_Name (from Stations db)
	@testid		char(50) = NULL, -- Scanned component serial number
	@Pass		char(3) = NULL, -- Scanned component serial number
	@first		char(2) = NULL, -- Scanned component serial number
	@acsmode	int = NULL, -- Scanned component serial number
              @tdate             datetime = getdate
as
    if not exists (select test_id from testlog where test_id = @testid)
    begin
	Begin Transaction
		--Save new subtestlog db record
		Insert into testlog
                           (
                              acs_serial, 
                               SAP_Model,
                               Station,
                               Test_ID,
                                Pass_Fail,
                                firstrun,
                                Test_Date_Time,
                                ACSEEMode     
                           )
		Values(@aserial, @sap, @sname, @testid, @Pass, @first,
			@tdate,@acsmode)
		if @@ERROR <> 0
		   begin
			--raiserror('E403.13 Serious Error. Failed to append record to assemblies db',17,1)
			Rollback Transaction
			return 12
		   end
	--Commit T-SQL transaction
	Commit Transaction
    end
GO