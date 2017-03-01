SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TRN_LoadData]
@begintlid int,
@beginstlid int,
@beginasylogid int,
@beginassemid int,
@begincatpartno int 
AS
set nocount on


declare @acsserial char(20)
declare @sapmodel char(20)
declare @station char(20)
declare @testid char(50)
declare @passfail char(3)
declare @firstrun char(2)
declare @tdatetime datetime
declare @mode int
declare @tlid int
declare @partnoname char(20)



declare @subtestname char(30)
declare @strValue char(20)
declare @intvalue int
declare @floatvalue real
declare @units char(30)
declare @comment char(80)
declare @stlid int

declare @maxlocalstlid int

declare @sid int

declare curTestLog CURSOR for
select ACS_Serial, SAP_Model, Station, Test_ID, Pass_Fail, FirstRun, Test_Date_Time, ACSEEMode, TL_ID
from TRN_testlog WHERE  TL_ID >= @begintlid and TL_ID not in
( select TRN_ID from TRN_tlid_mapping)
and ( test_id not in (  select test_id from testlog))


declare curSubTestLog CURSOR FOR
select ACS_Serial, Station, Subtest_Name, Test_ID, Pass_Fail, strValue, intValue, floatValue, Units, Comment, STL_ID
from TRN_subtestlog WHERE STL_ID >= @beginstlid  and STL_ID not in
( select TRNSTL_ID from TRN_stlid_mapping )


declare curCatalog CURSOR FOR
select distinct trn_catalog.part_no_name
 from trn_asylog
inner join TRN_Tffc_Serialnumbers 
on TRN_Asylog.acs_serial = TRN_TFFC_SerialNumbers.tffc_reservedby
inner join TRN_Stations on station = station_count
inner join TRN_Catalog on added_part_no = part_no_count
inner join stations on trn_stations.station_name = stations.station_name
where part_no_name not in
(
select part_no_name from catalog
)

open curTestLog

Fetch NEXT FROM curTestLog into @acsserial, @sapmodel, @station, @testid , @passfail , @firstrun , @tdatetime ,  @mode , @tlid 
WHILE @@FETCH_STATUS = 0
BEGIN

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
(@acsserial,
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
insert into TRN_TLID_Mapping
(
TRN_ID, DB1_ID, Transfer_Time
)
values
(
@tlid,
@sid,
getdate()
)
end

end

Fetch NEXT FROM curTestLog into @acsserial, @sapmodel, @station, @testid , @passfail , @firstrun , @tdatetime ,  @mode , @tlid 

END
close curTestLog
deallocate curTestLog

select @maxlocalstlid = max(STL_ID) from subtestlog


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
from TRN_subtestlog where
(STL_ID >=  @beginstlid )
and STL_ID
not in ( select subtestlog.STL_ID from subtestlog 
inner join TRN_subtestlog on TRN_subtestlog.acs_serial = subtestlog.acs_serial 
and TRN_subtestlog.station=subtestlog.station 
and TRN_subtestlog.subtest_name = subtestlog.subtest_name 
and TRN_subtestlog.test_id = subtestlog.test_id 
where TRN_subtestlog.STL_ID >= @beginstlid  
and subtestlog.STL_ID > (@maxlocalstlid - 100000)
)




open curCatalog
FETCH next from curCatalog into @partnoname
WHILE @@FETCH_STATUS = 0
begin

exec ame_create_part @partnoname
FETCH next from curCatalog into @partnoname
end
close curCatalog
deallocate curCatalog



insert into assemblies
(
ACS_Serial, SAP_Model_No, Start_Station, 
Top_Model_Prfx, Start_Mfg, PSC_Serial, End_Mfg, 
Sales_Order, Line_Item, Current_State
)
/*
select distinct trn_assemblies.acs_serial,
products.sap_count,stations.station_count,
trn_assemblies.top_model_prfx,
trn_assemblies.start_mfg, tffc_serialnumber,
trn_assemblies.end_mfg,
trn_assemblies.sales_order, 
trn_assemblies.line_item,
trn_assemblies.current_state from trn_assemblies
inner join testlog 
on TRN_Assemblies.acs_serial = testlog.acs_serial
inner join products on testlog.sap_model = products.sap_model_name
inner join TRN_Stations on start_station = station_count
inner join stations on TRN_Stations.station_name = stations.station_name
left outer join TRN_TFFC_SerialNumbers on trn_assemblies.acs_serial = TRN_TFFC_SerialNumbers.tffc_reservedby
where trn_assemblies.assem_id > @beginassemid
and trn_assemblies.acs_serial not in
(
select acs_serial from assemblies
)
and testlog.acs_serial like 'SMR%'
*/
select trn_assemblies.acs_serial,
products.sap_count,stations.station_count,
trn_assemblies.top_model_prfx,
trn_assemblies.start_mfg, tffc_serialnumber,
trn_assemblies.end_mfg,
trn_assemblies.sales_order, 
trn_assemblies.line_item,
trn_assemblies.current_state from trn_assemblies
inner join TRN_Tffc_Serialnumbers 
on TRN_Assemblies.acs_serial = TRN_TFFC_SerialNumbers.tffc_reservedby
inner join products on TFFC_Material = products.sap_model_name
inner join TRN_Stations on start_station = station_count
inner join stations on TRN_Stations.station_name = stations.station_name
where trn_assemblies.assem_id > @beginassemid
and trn_assemblies.acs_serial not in
(
select acs_serial from assemblies
)




insert into asylog
(
ACS_Serial, Station, Action, 
Added_Part_No, Scanned_Serial, 
Rev, Action_Date, 
Quantity
)
select trn_asylog.acs_serial,
stations.station_count,
trn_asylog.action,
catalog.part_no_count,
trn_asylog.scanned_serial,
trn_asylog.rev,
trn_asylog.action_date,
trn_asylog.quantity
 from trn_asylog
inner join TRN_Tffc_Serialnumbers 
on TRN_Asylog.acs_serial = TRN_TFFC_SerialNumbers.tffc_reservedby
inner join TRN_Stations on station = station_count
inner join TRN_Catalog on added_part_no = part_no_count
inner join stations on trn_stations.station_name = stations.station_name
inner join catalog on trn_catalog.part_no_name = catalog.part_no_name
where trn_asylog.asylog_id > @beginasylogid
GO