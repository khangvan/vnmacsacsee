SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_insertbulkBrazilweekly] 
 @startstlid int,
 @endstlid int
AS
declare @incstlid int
declare @laststlid int


--set @startstlid =61440786

--set @endstlid = 65888867


set @incstlid = 300000

set @laststlid = @startstlid

print 'before loop'
print @startstlid
print @endstlid
print @incstlid
print @laststlid

while @endstlid > @laststlid
begin
print 'doing loop'
print @laststlid

print getdate()

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
from weeklyBrazilsubtestlog where
(STL_ID >=  @laststlid )
and ( STL_ID < (@laststlid + @incstlid))
and STL_ID
not in ( select weeklybrazilsubtestlog.STL_ID from subtestlog 
inner join weeklybrazilsubtestlog on weeklybrazilsubtestlog.acs_serial = subtestlog.acs_serial 
and weeklybrazilsubtestlog.station=subtestlog.station 
and weeklybrazilsubtestlog.subtest_name = subtestlog.subtest_name 
and weeklybrazilsubtestlog.test_id = subtestlog.test_id 
where weeklybrazilsubtestlog.STL_ID >= @laststlid  
and ( weeklybrazilsubtestlog.STL_ID < (@laststlid + @incstlid)))

set @laststlid = @laststlid + @incstlid

end

print 'done with loop'
GO