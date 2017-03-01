SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_test_finish_wdatetime_DLM]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@sap		char(20) = NULL,
	@sname		char(20) = NULL, -- Station_Name (from Stations db)
	@testid		char(50) = NULL, -- Scanned component serial number
	@Pass		char(3) = NULL, -- Scanned component serial number
	@first		char(2) = NULL, -- Scanned component serial number
	@acsmode	int = NULL,
	@testdatetime datetime = NULL, -- Scanned component serial number
	@SapSerial char(20) = NULL
	
-- Define code
AS

declare @ortdate datetime
declare @count int
declare @firstcount int
declare @diffcalc int
declare @tdate datetime



	if @testdatetime = NULL
             begin
	set @tdate = getdate()
              end
              else
              begin
             set @diffcalc =DateDiff(d,@testdatetime,getdate())

                    if ( (@diffcalc > 30 ) or (@diffcalc < 0 ))
                    begin
                           set @tdate = getdate()
                    end
                    else
                    begin
                           set @tdate = @testdatetime
                    end
              end     
              declare @sid int    -- added by Bill Kurth

	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		return 2
	   end


       select @firstcount = count(*) from testlog where acs_serial=@aserial
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

select @ortdate = test_date_time  from testlog where acs_serial= @aserial
and SAP_Model = 'ENTERORT'

if @ortdate is not null
begin
   select @count = count(*) from testlog where acs_serial = @aserial
    and test_date_time > @ortdate
    and station = @sname
    if @count = 0 
    begin
       set @first='O'
    end
end
	Begin Transaction
		--Save new subtestlog db record
		Insert testlog ( ACS_Serial, SAP_Model, Station, Test_ID, Pass_Fail, FirstRun, Test_Date_Time, ACSEEMode )
		Values(@aserial, @sap, @sname, @testid, @Pass, @first,
			@tdate,@acsmode)
		if @@ERROR <> 0
		   begin
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

	return 1
GO