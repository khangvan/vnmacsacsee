SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LoadWeeklyBrazilData] 
@begintlid int,
@beginstlid int 
AS
set nocount on

declare @lastPANID int
declare @lastInsertedID int

declare @newlastPANID int

declare @acsserial char(20)
declare @sapmodel char(20)
declare @station char(20)
declare @testid char(50)
declare @passfail char(3)
declare @firstrun char(2)
declare @tdatetime datetime
declare @mode int
declare @tlid int


declare @lastPANSTLID int
declare @lastInsertedSTLID int
declare @newlastPANSTLID int


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
declare @jcnt int

declare @sid int

declare curTestLogs CURSOR FOR
select ACS_Serial, SAP_Model, Station, Test_ID, Pass_Fail, FirstRun, Test_Date_Time, ACSEEMode, TL_ID
from weeklybraziltestlog WHERE  TL_ID >= @begintlid and TL_ID not in
( select PAN_ID from BrazilTODB1map)
and ( test_id not in (  select test_id from testlog))


declare curSubTestLogs CURSOR FOR
select ACS_Serial, Station, Subtest_Name, Test_ID, Pass_Fail, strValue, intValue, floatValue, Units, Comment, STL_ID
from weeklybrazilsubtestlog WHERE STL_ID >= @beginstlid  and STL_ID < ( @beginstlid + 10000 ) and STL_ID not in
( select PANSTL_ID from BrazilSTLTODB1map )


/*
declare curStations CURSOR FOR
select Station_Count, Station_Name, Description, ACS_Serial_ID, Gen_PSC_Serial, Print_Asm_Label, Print_Unit_Label, Print_Carton_Label,
Print_Extra_Label, Allow_Overrides, Finish_Assembly, Perform_Test, Assign_Sales_Order, Backflush, Status, Machine_Name,
FactoryGroup_Mask, ProductGroup_Mask, order_value, thin_client, station_type, waterfall_server_machine_name, application_server_machine_name,
business_server_machine_name, STN_MfgLine_ID
from [panacsee].[dbo].PANStations where Station_Count > @laststncount and station_name not in ( select station_name from stations)


*/




select @lastPANID = LastBrazil_ID from PANWINCounters


select @lastPANSTLID = LastBrazil_STLID from PANWINCounters


select @laststncount = LastPANStnCount from PANWINCounters

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
    if not exists ( select ACS_Serial from assemblies where ACS_Serial=@acsserial )
   begin
   
    exec ame_create_label_format  @sapmodel

    select @sapcount = SAP_Count from products where  SAP_Model_name = @sapmodel

    if @sapcount is not null 
    begin
       select @stationcount = station_count from stations where station_name = @station
        if @stationcount is not null 
        begin
             
              insert into BRAZILBRAZILASSPROD
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

    insert into BRAZILBRAZILASSPROD
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
                   insert into BRAZILTODB1MAP
                   (
                      PAN_ID,
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


-- create assembly record if none exists



/*
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
@datetime,
@mode
)
               set @sid = scope_identity()
                if @sid is not null
               begin
                   insert into PANTODB1MAP
                   (
                      PAN_ID,
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


*/
end
Fetch NEXT FROM curTestLogs into @acsserial, @sapmodel, @station, @testid , @passfail , @firstrun , @tdatetime , @mode , @tlid 

END
close curTestLogs
deallocate curTestlogs

declare @minweeklystlid int
declare @maxweeklystlid int
declare @weeklyincrementstlid int


select @minweeklystlid = min(STL_ID) from weeklyBRAZILsubtestlog
select @maxweeklystlid = max(STL_ID) from weeklyBRAZILsubtestlog


set @jcnt = 0


print 'doing sub testlog'
print 'about to insert'

exec ame_insertbulkbrazilweekly @minweeklystlid, @maxweeklystlid
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
from weeklypansubtestlog where
STL_ID > @beginstlid 
and STL_ID < (@beginstlid + 10000)
and STL_ID
not in ( select weeklypansubtestlog.STL_ID from subtestlog 
inner join weeklypansubtestlog on weeklypansubtestlog.acs_serial = subtestlog.acs_serial 
and weeklypansubtestlog.station=subtestlog.station 
and weeklypansubtestlog.subtest_name = subtestlog.subtest_name 
and weeklypansubtestlog.test_id = subtestlog.test_id 
where weeklypansubtestlog.STL_ID > @beginstlid  )

*/

/*
set @jcnt = 0

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
                   insert into PANSTLTODB1MAP
                   (
                      PANSTL_ID,
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






select @newlastPANSTLID = max(STL_ID) from [pandata].[dbo].[subtestlog]
update PANWINCounters set LastPAN_STLID = @newlastPANSTLID
*/
GO