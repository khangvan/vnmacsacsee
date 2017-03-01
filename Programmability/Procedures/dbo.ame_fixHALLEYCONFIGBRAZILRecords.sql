SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_fixHALLEYCONFIGBRAZILRecords]
 AS

set nocount on

declare @origacsserial char(20)
declare @origsapmodel char(20)
declare @origstation char(20)
declare @origtestid char(50)
declare @origtestpassfail  char(3)
declare @origfirstrun char(2)
declare @origtestdatetime datetime
declare @origmode int
declare @origtlid int


declare @origstlacsserial char(20)
declare @origstlstation char(20)
declare @origstlsubtestname char(30)
declare @origstltestid char(50)
declare @origstlstlpassfail char(3)
declare @origstlstrvalue char(20)
declare @origstlintvalue int
declare @origstlfloatvalue real
declare @origstlunits char(30)
declare @origstlcomment char(80)
declare @origstlstlid int


declare @newacsserial char(20)
declare @newtestid char(50)
declare @newwtestdatetime datetime


declare @newminutecounter int
declare @newhourcounter int

declare @olddaydatepart char(20)
declare @daydatepart char(20)

declare @newchardatetime char(30)
declare @newdatetime datetime

declare @newhour char(2)
declare @newminute char(2)

declare @newrealtime char(30)


declare @newdatetimerep char(30)

declare cur_origtestrecords CURSOR FOR
select 
ACS_Serial, SAP_Model, Station, Test_ID, Pass_Fail, FirstRun, Test_Date_Time, ACSEEMode, TL_ID
 from testlog where station='HALLEY_CONFIG7'
and acs_serial like 'SA%'
order by test_date_time

set @olddaydatepart = '1900/01/01'




open cur_origtestrecords
FETCH NEXT FROM cur_origtestrecords
into
 @origacsserial,
 @origsapmodel,
 @origstation,
 @origtestid,
 @origtestpassfail,
 @origfirstrun,
 @origtestdatetime,
 @origmode,
 @origtlid 




WHILE @@FETCH_STATUS = 0 
BEGIN

print 'test record**********************************************************************************************************************************'
print @origacsserial
print @origtestid


set @daydatepart =convert(char(20),@origtestdatetime, 111)
set @daydatepart = CONVERT(VARCHAR(10), @origtestdatetime, 101)  --AS [MM/DD/YYYY]
print '@daydatepart'
print @daydatepart
if @daydatepart != @olddaydatepart
begin
set @olddaydatepart = @daydatepart
set @newminutecounter = 1
set @newhourcounter = 12
end
else
begin
if @newminutecounter > 58
begin
set @newminutecounter = 1
set @newhourcounter = @newhourcounter + 1
end
else
begin
set @newminutecounter = @newminutecounter + 1
end
end

print 'newminutecounter'
print @newminutecounter

print '@olddaydatepart'
print @olddaydatepart
set @newchardatetime = @olddaydatepart + ' '

print '@newchardatetime'
print @newchardatetime 
if  @newhourcounter < 10 
begin
set @newhour = '0' + cast(@newhourcounter as char(1)) 
end
else
begin
set @newhour = cast(@newhourcounter as char(2))
end

set @newchardatetime = rtrim(@newchardatetime) + ' '
print @newchardatetime
if @newminutecounter < 10
begin
set @newminute =  '0' + cast(@newminutecounter as char(1))
end
else
begin
set @newminute =  cast(@newminutecounter as char(2))
end

print @newhourcounter
print @newminutecounter
print @newhour
print @newminute
print @newchardatetime
print @newhour
set @newchardatetime = rtrim(@newchardatetime) -- + rtrim(@newhour)
print @newchardatetime
print '@newrealtime'
set @newrealtime = rtrim(@newchardatetime) + ' ' + rtrim(@newhour) +':' + rtrim(@newminute) +':00 AM'
print @newrealtime

set @newacsserial= 'SBZ' + substring(@origacsserial,3,12)
print @newacsserial
if substring(@newrealtime,1,1)='0'
begin
set @newrealtime = substring(@newrealtime,2,30)
end
set @newtestid = 'HALLEY_CONFIG7' + @newrealtime
print @newtestid

set  @newwtestdatetime  = @newrealtime
print @newwtestdatetime
--print @newchardatetime
--set @newdatetime = cast(@newrealtime as datetime)
--print @newdatetime
--print ' '
--set @newdatetimerep = convert(char(30),@newdatetime,20)
--print @newdatetimerep


/*   to actually insert new records   
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
@newacsserial,
@origsapmodel,
 @origstation,
 @newtestid,
 @origtestpassfail,
 @origfirstrun,
 @newwtestdatetime,
 @origmode
)

 */

declare cur_origsubtestrecords CURSOR FOR
select 
ACS_Serial, Station, SubTest_Name, Test_ID, Pass_Fail, strValue, intValue, floatValue, Units, Comment, STL_ID
 from subtestlog
where station='HALLEY_CONFIG7'
and acs_serial like 'SA%'
and Test_ID = @origtestid



print 'opening subtest cursor'
open cur_origsubtestrecords
print 'opened cursor'
FETCH NEXT FROM cur_origsubtestrecords
into
@origstlacsserial,
@origstlstation,
@origstlsubtestname,
@origstltestid,
@origstlstlpassfail,
@origstlstrvalue,
@origstlintvalue,
@origstlfloatvalue,
@origstlunits,
@origstlcomment,
@origstlstlid 

WHILE @@FETCH_STATUS = 0 
begin

print 'subtest record ---'
print @origstlsubtestname
print ' '

/*  this actually does it for subtestlog records  
insert into subtestlog
(
ACS_Serial, 
Station, 
SubTest_Name, 
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
@newacsserial,
@origstlstation,
@origstlsubtestname,
@newtestid,
@origstlstlpassfail,
@origstlstrvalue,
@origstlintvalue,
@origstlfloatvalue,
@origstlunits,
@origstlcomment
)
   */

FETCH NEXT FROM cur_origsubtestrecords
into
@origstlacsserial,
@origstlstation,
@origstlsubtestname,
@origstltestid,
@origstlstlpassfail,
@origstlstrvalue,
@origstlintvalue,
@origstlfloatvalue,
@origstlunits,
@origstlcomment,
@origstlstlid 
end

close cur_origsubtestrecords
deallocate cur_origsubtestrecords







FETCH NEXT FROM cur_origtestrecords
into
 @origacsserial,
 @origsapmodel,
 @origstation,
 @origtestid,
 @origtestpassfail,
 @origfirstrun,
 @origtestdatetime,
 @origmode,
 @origtlid 
END


close cur_origtestrecords
deallocate cur_origtestrecords
GO