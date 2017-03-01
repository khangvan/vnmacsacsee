SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE proc [dbo].[ame_test_finish]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@sap		char(20) = NULL,
	@sname		char(20) = NULL, -- Station_Name (from Stations db)
	@testid		char(50) = NULL, -- Scanned component serial number
	@Pass		char(3) = NULL, -- Scanned component serial number
	@first		char(2) = NULL, -- Scanned component serial number
	@acsmode	int = NULL -- Scanned component serial number
	
-- Define code
AS
              declare @ortdate datetime
declare @count int
declare @firstcount int
	declare @tdate datetime
	set @tdate = getdate()     
              declare @sid int    -- added by Bill Kurth

	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		--raiserror ('E403.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			--16,1) with nowait
		return 2
	   end


       select @firstcount = count(*) from testlog with(NOLOCK) where acs_serial=@aserial
       and test_date_time < @tdate
       and station = @sname
       if @firstcount > 0
       begin
           set @first = 'N'
       end
       else
       begin
          set @first ='Y'
       end 

select @ortdate = test_date_time  from testlog with(NOLOCK) where acs_serial= @aserial
and SAP_Model = 'ENTERORT'

if @ortdate is not null
begin
   select @count = count(*) from testlog with(NOLOCK) where acs_serial = @aserial
    and test_date_time > @ortdate
    and station = @sname
    if @count = 0 
    begin
       set @first='O'
    end
end
	Begin Transaction
		--Save new subtestlog db record
		Insert testlog  ( ACS_Serial, SAP_Model, Station, Test_ID, Pass_Fail, FirstRun, Test_Date_Time, ACSEEMode )
		Values(@aserial, @sap, @sname, @testid, @Pass, @first, @tdate,@acsmode)
		if @@ERROR <> 0
		   begin
			--raiserror('E403.13 Serious Error. Failed to append record to assemblies db',17,1)
			Rollback Transaction
			return 12
		   end
	--Commit T-SQL transaction
	Commit Transaction
             -- Bill Kurth's code to add record to RawFruFailureLog
            if LTRIM(RTRIM(@Pass)) = 'F'
            begin
               set @sid = scope_identity()
                if @sid is not null
                begin
                    exec ame_AddRecordToFailureLog @sid, @aserial, @sap, @sname, @first, @tdate, @testid
                 end
             end
             -- Finish Bill Kurth's addition
	return 1
-- Create the Stored Procedure
GO