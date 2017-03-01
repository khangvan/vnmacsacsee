SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_fixbrazilort] AS


set nocount on

declare @tlid int
declare @testid char(50)
declare @newtestid char(50)
declare cur_tests CURSOR FOR
select TL_ID, test_id from testlog where station='ACSEEORT9'
and test_id like 'ACSEEORTBRZ%'


Open cur_tests 

FETCH NEXT FROM cur_tests INTO @tlid, @testid

while @@FETCH_STATUS = 0 
begin


set @newtestid = 'ACSEEORT9' + substring(@testid,12,35)
print @newtestid


update testlog set test_id = @newtestid where tl_id = @tlid

FETCH NEXT FROM cur_tests INTO @tlid, @testid
end


close cur_tests
deallocate cur_tests
GO