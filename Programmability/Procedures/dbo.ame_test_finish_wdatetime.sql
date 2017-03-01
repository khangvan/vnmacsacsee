SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_test_finish_wdatetime]
-- Define input parameters
    @aserial    char(20) = NULL, -- ACS_Serial
    @sap        char(20) = NULL,
    @sname    char(20) = NULL, -- Station_Name (from Stations db)
    @testid        char(50) = NULL, -- Test unique ID
    @Pass        char(3) = NULL, -- Pas Fail result
    @first        char(2) = NULL, -- first run
    @acsmode    int = NULL, -- ACS working mode
    @testdatetime datetime = NULL, -- date time of performed test, for TM use only
    @SapSerial char(20) = NULL -- SAP serial assigned to unit during FFC
    
-- Define code
AS
declare @ortdate datetime
declare @count int
declare @firstcount int
declare @diffcalc int
declare @tdate datetime
declare @Kicker_ID int
declare @TFFC_TestFinish_ID int
declare @assemid int
declare @lociacsserial char(20)

-- for loci update
declare @nextstation char(20)
declare @loci_ACS_serial char(20)
declare @loci_ORT_Status  char(5)
declare @loci_ORT_Bin char(5)
declare @loci_ORT_Start  char(20)
declare @loci_PSC_Serial  char(20)
declare @loci_Assembly_ACSSN char(20)
declare @loci_SAP_Model char(20)
declare @loci_sievebyte int
declare @loci_linebyte int
declare @loci_UnitStnByte  int
declare @loci_PlantByte int
declare @loci_Next_Station_Name char(20)
declare @loci_Last_Event_Date datetime
declare @loci_Test_ID char(50)
declare @loci_Station char(20)

--for double test retvalue

declare @TotalResult int
declare @move int
declare @NewNextStation char(50)

-- constant values

declare @DT_NextStation char(20)
declare @DT_FirstStation char(20)



if @testdatetime = NULL
begin
    set @tdate = getdate()
end
else
begin
    set @diffcalc =DateDiff(d,@testdatetime,getdate())
--print @diffcalc

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
    --raiserror ('E403.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
        --16,1) with nowait
    return 2
    end


select @firstcount = count(*) 
    from testlog with(NOLOCK)
    where acs_serial=@aserial 
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

select @ortdate = test_date_time  
    from testlog 
    where acs_serial= @aserial 
        and SAP_Model = 'ENTERORT'

if @ortdate is not null
begin
    select @count = count(*) 
        from testlog with(NOLOCK)
        where acs_serial = @aserial
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
        --raiserror('E403.13 Serious Error. Failed to append record to assemblies db',17,1)
        Rollback Transaction
        return 12
    end
    if @SapSerial is not null
    begin
        select @assemid = Assem_ID from assemblies with(NOLOCK) where acs_serial = @aserial
        if @assemid is not null
        begin
            update assemblies set PSC_Serial = @SapSerial where assem_id = @assemid
        end
--        if exists ( select AcS_Serial from [ACSEEState].[dbo].loci WITH (NOLOCK)  where acs_serial = @aserial )
--       begin
--            update [ACSEEState].[dbo].loci set PSC_Serial = @SapSerial where acs_serial = @aserial
--        end
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
-- add TFFC line logic to record testfinish in TFFC_TestFinish table
select @Kicker_ID = TFFC_Kicker_ID 
from TFFC_Kicker_Table with(NOLOCK)
where TFFC_Kicker_Model = @sap and TFFC_Kicker_TestType = 'TM'

-- Update Loci for TM started by Kicker
if @Kicker_ID is not null and LTRIM(RTRIM(@Pass)) = 'P'
begin
    select @nextstation = TFFC_Kicker_QBuddies 
        from TFFC_Kicker_Table 
        where TFFC_Kicker_ID  = @Kicker_ID

        select     @loci_ACS_Serial = ACS_serial,
        @loci_ORT_Status = ORT_Status,  
        @loci_ORT_Bin = ORT_Bin,
        @loci_ORT_Start =ORT_Start, 
        @loci_PSC_Serial = PSC_Serial,  
        @loci_Assembly_ACSSN =Assembly_ACSSN,
        @loci_SAP_Model =SAP_Model,
        @loci_SieveByte = SieveByte,
        @loci_UnitStnByte = UnitStnByte, 
        @loci_LineByte = LineByte,
        @loci_PlantByte = PlantByte,
        @loci_Last_Event_Date = Last_Event_Date,
        @loci_Test_ID = Test_ID,
        @loci_Station =Station
        from  [ACSEEState].[dbo].Loci WITH (NOLOCK) 
        where ACS_Serial = @aserial

    exec [ACSEEState].[dbo].ame_update_loci
        @loci_ACS_Serial, 
        @loci_SAP_Model, 
        @loci_ORT_Status,
        @loci_ORT_Bin  , 
        @loci_ORT_Start  ,
        @SapSerial,                                    --@loci_PSC_Serial,
        @loci_assembly_ACSSN,
        @loci_SieveByte, 
        @loci_UnitStnByte,
        @Loci_LineByte , 
        @Loci_PlantByte,
        @nextstation ,
        @loci_Test_ID ,
        @loci_Station 
end
else 
begin
    -- check if the model is a subassembly (740, 5- 50- 51-)
    if substring(@sap,1,2)='74' or substring(@sap,1,1)='5' 
    begin
        -- @SapModel is a base model, so this is a final test
        print /*select*/ 'This is a base model'
        
        set @DT_NextStation = 'ACSVNONESTART'
        set @DT_FirstStation = 'TMFinalTest'

    end
    else -- if is not a base model it uses different prev and next srtation
    begin
        -- @SapModel is a base model, so this is a board test, it don't have to go to FFC
        print /*select*/ 'This is not a base model'
        
        set @DT_NextStation = 'TMPostTest'
        set @DT_FirstStation = 'TMPreTest'
    end
    
    select     @loci_ACS_Serial = ACS_serial,
        @loci_ORT_Status = ORT_Status,  
        @loci_ORT_Bin = ORT_Bin,
        @loci_ORT_Start =ORT_Start, 
        @loci_PSC_Serial = PSC_Serial, 
        @loci_Assembly_ACSSN =Assembly_ACSSN,
        @loci_SAP_Model =SAP_Model,
        @loci_SieveByte = SieveByte,
        @loci_UnitStnByte = UnitStnByte, 
        @loci_LineByte = LineByte,
        @loci_PlantByte = PlantByte,
        @loci_Last_Event_Date = Last_Event_Date,
        @loci_Test_ID = Test_ID,
        @loci_Station =Station,
        @loci_Next_Station_Name = Next_Station_Name
    from  [ACSEEState].[dbo].Loci WITH (NOLOCK) 
        where ACS_Serial = @aserial

    if @loci_ACS_Serial is null
    begin    
    -- there is no loci entry for this unit, I'm creating it with
    -- Station and NextStationName as TMFinalTest
        exec [ACSEEState].[dbo].ame_Create_loci @aserial,@sap,0,0,0,0,@DT_FirstStation,@TestID,@DT_FirstStation,'';
        
        select     @loci_ACS_Serial = ACS_serial,
            @loci_ORT_Status = ORT_Status,  
            @loci_ORT_Bin = ORT_Bin,
            @loci_ORT_Start =ORT_Start, 
            @loci_PSC_Serial = PSC_Serial, 
            @loci_Assembly_ACSSN =Assembly_ACSSN,
            @loci_SAP_Model =SAP_Model,
            @loci_SieveByte = SieveByte,
            @loci_UnitStnByte = UnitStnByte, 
            @loci_LineByte = LineByte,
            @loci_PlantByte = PlantByte,
            @loci_Last_Event_Date = Last_Event_Date,
            @loci_Test_ID = Test_ID,
            @loci_Station =Station,
            @loci_Next_Station_Name = Next_Station_Name
        from  [ACSEEState].[dbo].Loci WITH (NOLOCK) 
            where ACS_Serial = @aserial
        
    end
    
    -- update loci for all other models not started by Kicker, for all final test check
    -- change made by S. Barozzi on Jan 20 2013.
    exec @TotalResult = [ACS EE].[dbo].ame_TM_DoubleTestCheck @aserial, @sap, @sname, @testid, @Pass;
            
    if (@TotalResult=1)
    begin
        print /*select*/ 'All result are pass'
        if (rtrim(@loci_Next_Station_Name)=@DT_NextStation)
        begin
            print /*select*/ 'Next Station is OK '+@loci_Next_Station_Name+' = '+@DT_NextStation
            set @move = 0
        end
        else 
        begin
            if (rtrim(@loci_Next_Station_Name)=@DT_FirstStation)
            begin
                print /*select*/ 'Move forward to NextStation '+@loci_Next_Station_Name+' --> '+@DT_NextStation
                set @move = 1
                set @NewNextStation = @DT_NextStation
            end
            else
            begin
                print /*select*/ 'Wrong Next Station '+@loci_Next_Station_Name
                set @move = 0
            end
        end
    end
    else
    begin
        print /*select*/ 'At least one result is fail'
        if (rtrim(@loci_Next_Station_Name)=@DT_NextStation)
        begin
            print /*select*/ 'Move back to FirstStation '+@loci_Next_Station_Name+' --> '+@DT_FirstStation
            set @move = 1
            set @NewNextStation = @DT_FirstStation
        end
        else 
        begin
            if (rtrim(@loci_Next_Station_Name)=@DT_FirstStation)
            begin
                print /*select*/ 'Next Station is OK '+@loci_Next_Station_Name+' = '+@DT_FirstStation
                set @move = 0
            end
            else
            begin
                print /*select*/ 'Wrong Next Station '+@loci_Next_Station_Name
                set @move = 0
            end
        end
    end            


    if (@move=1)
    begin
        print /*select*/ 'Updated Loci'
        -- update loci with @NewNextStation e @TestID
        
        exec [ACSEEState].[dbo].ame_update_loci
            @loci_ACS_Serial,
            @loci_SAP_Model,
            @loci_ORT_Status,  
            @loci_ORT_Bin,
            @loci_ORT_Start, 
            @loci_PSC_Serial, 
            @loci_Assembly_ACSSN,
            @loci_SieveByte,
            @loci_UnitStnByte, 
            @loci_LineByte,
            @loci_PlantByte,
            @NewNextStation,
            @TestID,
            @loci_Station;
    end    
end


return 1
-- Create the Stored Procedure
GO