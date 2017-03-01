SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO


CREATE PROCEDURE [dbo].[ame_AddRecordtoFailureLog] 
 @tlid int,
 @sn char(20),
 @sap char(20),
 @station char(20),
 @firstrun char(10),
 @testdatetime datetime,
 @testid char(50)

 
as
declare @repairaction int
declare @causecategory int
declare @origincode int
declare @fruid int
declare @type int
declare @fGood int
declare @iFailurePos int
declare @subtestname varchar(80)
declare @Failure varchar(80)
declare @curdate datetime
declare @testname varchar(80)
declare @inPCB int
declare @counter int

declare @ort char(10)

declare cur_SubtestFails CURSOR FOR
select subtest_name FROM subtestfailures with(NOLOCK) WHERE test_id = @testid


set @Failure = '' 
set @iFailurePos = 0
set @fGood = 0

if len(@station) > 1
begin
set @testname = substring(@station,1,len(RTRIM(@station)) -1 )
select @inPCB = TST_fInPCB from Tests with(NOLOCK) where STN_Name = @station
end
/*
if  @sap like '3-%' 
BEGIN
   set @type = 2
   set @repairaction = 12
   set @causecategory = 1
   set @origincode = 20
   set @fruid = 44
END
*/
if @inPCB = 1
BEGIN
   set @type = 2
--   set @repairaction = 12
--   if @firstrun = 'O'
 --  begin
       set @repairaction = 20
--   end
   set @causecategory = 1
   set @origincode = 20
   set @fruid = 256
END
else
BEGIN
   set @type = 1
--  set @repairaction = 1
--   if @firstrun = 'O'
--   begin
      set @repairaction = 19
--   end
   set @causecategory = 1
   set @origincode = 19
   set @fruid = 1

END
 
if @firstrun = 'O'
begin
set @ort ='Y'
end
else
begin
set @ort = 'N'
end
set @counter = 0
open cur_subtestFails

FETCH NEXT FROM cur_SubtestFails INTO @subtestname
WHILE  ( @@FETCH_STATUS = 0 ) AND ( @fGood = 0 ) AND (@counter < 3 )
BEGIN
   set @counter = @counter + 1
   set @subtestname = ltrim(rtrim(@subtestname))
   if (( @iFailurePos + len(@subtestname)) < 80 )
  begin
     if @iFailurePos > 0 
     begin
        set @Failure = @Failure + ','
     end
      set @Failure = @Failure + @subtestname
     set @iFailurePos = len(@Failure)
     FETCH NEXT FROM cur_SubtestFails INTO @subtestname
  end
  else
  begin
      set @fGood = 1
  end
END

close cur_subtestFails
deallocate cur_subtestFails

set @curdate = getdate()

insert into RawFruFailureLog
(
FLG_RepairAction_ID,
FLG_CauseCategory_ID,
FLG_OriginCode_ID,
FLG_Fru_ID,
FLG_ACSSN_ID,
FLG_TL_ID,
FLG_ACSSN,
FLG_Failure,
FLG_Station_ID,
FLG_Station,
FLG_RootCauseComment,
FLG_RootCauseOwner,
FLG_Critical,
FLG_ORT,
FLG_Technician,
FLG_PreventativeAction,
FLG_Comments,
FLG_FailureLogDate,
FLG_DateGrouping_ID,
FLG_Type,
FLG_Touched,
FLG_ReportType,
FLG_Generated,
FLG_LastModified
) values
(
@repairaction,
@causecategory,
@origincode,
@fruid,
0,
@tlid,
@sn,
@Failure,
0,
@Station,
'',
'',
1,
@ort,
'',
'',
'',
@testdatetime,
0,
@type,
0,
0,
0,
@curdate
)
GO