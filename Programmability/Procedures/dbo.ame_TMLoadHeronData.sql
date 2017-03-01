SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TMLoadHeronData]
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
from TM_testlog WHERE   TL_ID not in
( select TM_ID from TM_tlid_mapping)
and ( test_id not in (  select test_id from testlog))


declare curSubTestLog CURSOR FOR
select ACS_Serial, Station, Subtest_Name, Test_ID, Pass_Fail, strValue, intValue, floatValue, Units, Comment, STL_ID
from TRN_subtestlog WHERE STL_ID not in
( select TRNSTL_ID from TRN_stlid_mapping )



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
insert into TM_TLID_Mapping
(
TM_ID, DB1_ID, Transfer_Time
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
from TM_subtestlog where
STL_ID
not in ( select subtestlog.STL_ID from subtestlog 
inner join TM_subtestlog on TM_subtestlog.acs_serial = subtestlog.acs_serial 
and TM_subtestlog.station=subtestlog.station 
and TM_subtestlog.subtest_name = subtestlog.subtest_name 
and TM_subtestlog.test_id = subtestlog.test_id 
where subtestlog.STL_ID > (@maxlocalstlid - 1000000)
)
GO