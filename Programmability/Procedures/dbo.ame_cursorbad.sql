SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_cursorbad] AS
deallocate curTestLogs
deallocate curSubTestLogs

declare @acsserial char(20)
declare @sapmodel char(20)
declare @station char(20)
declare @testid char(50)
declare @passfail char(3)
declare @firstrun char(2)
declare @tdatetime datetime
declare @mode int
declare @tlid int

declare @jcnt int


declare curTestLogs CURSOR FOR
select ACS_Serial, SAP_Model, Station, Test_ID, Pass_Fail, FirstRun, Test_Date_Time, ACSEEMode, TL_ID
from weeklypantestlog WHERE  TL_ID >= 1330630 and TL_ID not in
( select PAN_ID from PANTODB1map)



select ACS_Serial, SAP_Model, Station, Test_ID, Pass_Fail, FirstRun, Test_Date_Time, ACSEEMode, TL_ID
from weeklypantestlog WHERE  TL_ID >= 1330630 and TL_ID not in
( select PAN_ID from PANTODB1map)

set @jcnt = 0

print 'doing testlog'

print 'a'

Open curTestLogs
Fetch NEXT FROM curTestLogs into @acsserial, @sapmodel, @station, @testid ,
 @passfail , @firstrun , @tdatetime , @mode , @tlid 
print 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'
print 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'
print 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'
print 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'
print 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'
print 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'
print 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'

WHILE @@FETCH_STATUS = 0
BEGIN
print 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'
print 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'
print 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'
print 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'
print 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'
print 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'
print 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'

print 'b'

set @jcnt = @jcnt + 1
print @jcnt
Fetch NEXT FROM curTestLogs into @acsserial, @sapmodel, @station, @testid , 
@passfail , @firstrun , @tdatetime , @mode , @tlid 

END


close curTestLogs
deallocate curTestlogs

print 'hwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwh'
print 'hwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwh'
print 'hwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwh'
print 'hwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwh'
print 'hwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwhwh'

select 'done'
GO