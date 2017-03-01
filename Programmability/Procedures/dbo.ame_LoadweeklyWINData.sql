SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LoadweeklyWINData]
@begintlid int,
@beginstlid int
 AS

declare @lastWINID int
declare @lastInsertedID int
declare @newlastWINID int


declare @acsserial char(20)
declare @sapmodel char(20)
declare @station char(20)
declare @testid char(50)
declare @passfail char(3)
declare @firstrun char(2)
declare @tdatetime datetime
declare @mode int
declare @tlid int


declare @lastWINSTLID int
declare @lastInsertedSTLID int
declare @newlastWINSTLID int

 
declare @subtestname char(30)
declare @strValue char(20)
declare @intvalue int
declare @floatvalue real
declare @units char(30)
declare @comment char(80)
declare @stlid int




declare @stncount int
declare @stnname char(20)
declare @stndescription char(40)
declare @acsserialid char(2)
declare @genpscserial char(1)
declare @printasmlabel char(1)
declare @printunitlabel char(1)
declare @printcartonlabel char(1)
declare @printextralabel char(1)
declare @allowoverrides char(1)
declare @performtest char(1)
declare @assignsalesorder char(1)
declare @backflush char(1)
declare @status char(1)
declare @machinename char(30)
declare @factorymask int
declare @productmask int
declare @ordervalue int
declare @thinclient char(1)
declare @stationtype char(3)
declare @waterfall char(20)
declare @application char(20)
declare @business char(20)
declare @mfglineid int


declare @laststncount int
declare @newlaststncount int

declare @sapcount int
declare @stationcount int

declare @sid int

declare @jcnt int

declare curTestLogs CURSOR FOR
select ACS_Serial, SAP_Model, Station, Test_ID, Pass_Fail, FirstRun, Test_Date_Time, ACSEEMode, TL_ID
from weeklywintestlog WHERE  TL_ID >= @begintlid  and TL_ID not in
( select WIN_ID from WINTODB1map )
and test_id not in ( select test_id from testlog )


declare curSubTestLogs CURSOR FOR
select ACS_Serial, Station, Subtest_Name, Test_ID, Pass_Fail, strValue, intValue, floatValue, Units, Comment, STL_ID
from weeklywinsubtestlog WHERE  STL_ID >= @beginstlid and  STL_ID not in
( select WINSTL_ID from WINSTLTODB1map)
and test_id not in ( select test_id from testlog)


/*
declare curStations CURSOR FOR
select Station_Count, Station_Name, Description, ACS_Serial_ID, Gen_PSC_Serial, Print_Asm_Label, Print_Unit_Label, Print_Carton_Label,
Print_Extra_Label, Allow_Overrides, Finish_Assembly, Perform_Test, Assign_Sales_Order, Backflush, Status, Machine_Name,
FactoryGroup_Mask, ProductGroup_Mask, order_value, thin_client, station_type, waterfall_server_machine_name, application_server_machine_name,
business_server_machine_name, STN_MfgLine_ID
from [wincacsee].[dbo].Stations where Station_Count > @laststncount and Station_name not in 
( select station_name from stations )
*/

select @lastWINID = LastWin_ID from PANWINCounters

select @lastWINSTLID = LastWin_STLID from PANWINCounters

select @laststncount = LastWINStnCount from PANWINCounters


/*
open curStations
Fetch NEXT FROM curStations into  @stncount, @stnname, @stndescription, @acsserialid , @genpscserial,
 @printasmlabel , @printunitlabel , @printcartonlabel , @printextralabel , @allowoverrides , @performtest , @assignsalesorder ,
 @backflush , @status , @machinename , @factorymask , @productmask , @ordervalue , @thinclient ,
 @stationtype , @waterfall, @application , @business , @mfglineid 

WHILE @@FETCH_STATUS = 0
BEGIN

insert into stations
(
Station_Count,
Station_Name,
Description,
ACS_Serial_ID,
Gen_PSC_Serial,
Print_Asm_Label,
Print_Unit_Label,
Print_Carton_Label,
Print_Extra_Label,
Allow_Overrides,
Finish_Assembly,
Perform_Test,
Assign_Sales_Order,
Backflush,
Status,
Machine_Name,
FactoryGroup_Mask,
ProductGroup_Mask,
Order_Value,
Thin_Client,
station_type, 
waterfall_server_machine_name, 
application_server_machine_name,
business_server_machine_name,
 STN_MfgLine_ID

)
values
(
 @stncount, @stnname, @stndescription, @acsserialid , @genpscserial,
 @printasmlabel , @printunitlabel , @printcartonlabel , @printextralabel , @allowoverrides , @performtest , @assignsalesorder ,
 @backflush , @status , @machinename , @factorymask , @productmask , @ordervalue , @thinclient ,
 @stationtype , @waterfall, @application , @business , @mfglineid 

)



Fetch NEXT FROM curStations into  @stncount, @stnname, @stndescription, @acsserialid , @genpscserial,
 @printasmlabel , @printunitlabel , @printcartonlabel , @printextralabel , @allowoverrides , @performtest , @assignsalesorder ,
 @backflush , @status , @machinename , @factorymask , @productmask , @ordervalue , @thinclient ,
 @stationtype , @waterfall, @application , @business , @mfglineid 

END

close curStations
deallocate curStations

*/


set @jcnt = 0

print 'doing testlog'

Open curTestLogs
Fetch NEXT FROM curTestLogs into @acsserial, @sapmodel, @station, @testid , @passfail , @firstrun , @tdatetime , @mode , @tlid 

WHILE @@FETCH_STATUS = 0
BEGIN

set @jcnt = @jcnt + 1
print @jcnt
if ( @jcnt % 1000) = 0 
begin
   print ' in testlog'
  print @jcnt
end
   if not exists ( select TL_ID from testlog where acs_serial = @acsserial and test_id = @testid and station=@station )
   begin

-- create assembly record if none exists
    if not exists ( select ACS_Serial from assemblies where ACS_Serial=@acsserial )
   begin
   
    exec ame_create_label_format  @sapmodel

    select @sapcount = SAP_Count from products where  SAP_Model_name = @sapmodel

    if @sapcount is not null 
    begin
       select @stationcount = station_count from stations where station_name = @station
        if @stationcount is not null 
        begin
             
              insert into PANASSPROD
              (ACSSerial,
               SAP_Count,
               Station_count)
              values
               (
                 @acsserial,
                  @sapcount,
                @stationcount       
               )

               insert into assemblies 
               (
                acs_serial,
               SAP_Model_No,
               Start_station,
              Top_Model_Prfx,
               Start_Mfg,
               End_Mfg,
               Sales_Order,
               Line_item,
               Current_State
               )
               values
               (
              @acsserial,
              @sapcount,
              @stationcount,
              '5',
              @tdatetime,
              @tdatetime,
              0,
             0,
             'A'
            )
          end
      end 
    end


if not exists ( select SAP_Count from products where SAP_Model_Name = @sapmodel )
begin
    exec ame_create_label_format  @sapmodel

select @sapcount = SAP_Count from products where  SAP_Model_name = @sapmodel

    insert into PANASSPROD
    (ACSSErial,
      SAP_Count,
      Station_Count)
     values
     (
         @acsserial,
          @sapcount,
          NULL
     )

end

select @sapcount = SAP_Count from products where  SAP_Model_name = @sapmodel

if @sapcount is not null 
begin
       select @stationcount = station_count from stations where station_name = @station

     if @stationcount is not null 
    begin

        if not exists ( select test_id from testlog where test_id = @testid )
        begin
        insert into testlog
        (
       ACS_Serial,
       SAP_Model,
       Station,
       Test_ID,
       Pass_Fail,
       FirstRun,
      Test_Date_Time,
      ACSEEMode
      )
      values
      (
      @acsserial,
      @sapmodel,
      @station,
      @testid,
      @passfail,
      @firstrun,
      @tdatetime,
      @mode
      )
               set @sid = scope_identity()
                if @sid is not null
               begin
                   insert into WINTODB1MAP
                   (
                      WIN_ID,
                      DB1_ID,
                      Transfer_Time
                   )
                   values
                   (
                         @tlid,
                         @sid,
                         getdate()
                   )
               end

         end
       end
   end
end
Fetch NEXT FROM curTestLogs into @acsserial, @sapmodel, @station, @testid , @passfail , @firstrun , @tdatetime , @mode , @tlid 

END
close curTestLogs
deallocate curTestlogs

set @jcnt = 0

print 'about to do subtestlog'
/*
insert into subtestlog
(
ACS_Serial,
Station,
Subtest_Name,
Test_ID,
Pass_Fail,
strValue,
intValue,
floatValue,
Units,
Comment
)
*/

/*
open curSubtestlogs
Fetch next from curSubtestlogs into @acsserial, @station,@subtestname, @testid, @passfail, @strvalue, @intvalue, @floatValue, @Units, @Comment, @stlid
WHILE @@FETCH_STATUS = 0
BEGIN

set @jcnt = @jcnt + 1
print @jcnt
if ( @jcnt % 1000) = 0 
begin
print ' in subtestlog'
  print @jcnt
end
if not exists ( select STL_ID from subtestlog where acs_serial = @acsserial and station=@station and subtest_name = @subtestname and test_id = @testid)
begin

insert into subtestlog
(
ACS_Serial,
Station,
Subtest_Name,
Test_ID,
Pass_Fail,
strValue,
intValue,
floatValue,
Units,
Comment
)
values
(
@acsserial,
@station,
@subtestname,
@testid,
@passfail,
@strValue,
@intValue,
@floatValue,
@units,
@comment
)

                set @sid = scope_identity()
                if @sid is not null
               begin
                   insert into WINSTLTODB1MAP
                   (
                      WINSTL_ID,
                      DB1STL_ID,
                      Transfer_Time
                   )
                   values
                   (
                         @stlid,
                         @sid,
                         getdate()
                   )
               end

end

Fetch next from curSubtestlogs into @acsserial, @station,@subtestname, @testid, @passfail, @strvalue, @intvalue, @floatValue, @Units, @Comment, @stlid

END
close curSubtestlogs
deallocate cursubtestlogs

select @newlastWINID = max(TL_ID) from [wincacsee].[dbo].testlog
update PANWINCounters set LastWin_ID = @newlastWINID





select @newlastWINSTLID = max(STL_ID) from [wincacsee].[dbo].[subtestlog]
update PANWINCounters set LastWin_STLID = @newlastWINSTLID
*/
/*

insert into subtestlog
(
ACS_Serial,
Station,
Subtest_Name,
Test_ID,
Pass_Fail,
strValue,
intValue,
floatValue,
Units,
Comment
)
select ACS_Serial, 
Station, 
Subtest_Name, 
Test_ID, 
Pass_Fail, 
strValue, 
intValue, 
floatValue, 
Units,
 Comment
from weeklywinsubtestlog where
STL_ID > @beginstlid 
and STL_ID
not in ( select weeklywinsubtestlog.STL_ID from subtestlog 
inner join weeklywinsubtestlog on weeklywinsubtestlog.acs_serial = subtestlog.acs_serial 
and weeklywinsubtestlog.station=subtestlog.station 
and weeklywinsubtestlog.subtest_name = subtestlog.subtest_name 
and weeklywinsubtestlog.test_id = subtestlog.test_id 
where weeklywinsubtestlog.STL_ID > @beginstlid  )
*/


declare @minweeklystlid int
declare @maxweeklystlid int
declare @weeklyincrementstlid int


select @minweeklystlid = min(STL_ID) from weeklywinsubtestlog
select @maxweeklystlid = max(STL_ID) from weeklywinsubtestlog


set @jcnt = 0


print 'doing sub testlog'
print 'about to insert'

exec ame_insertbulkwinweekly @minweeklystlid, @maxweeklystlid
GO