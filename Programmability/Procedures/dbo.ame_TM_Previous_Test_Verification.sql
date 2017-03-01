SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TM_Previous_Test_Verification]
@acsserial char(20) =NULL,
@subtest_name char(30)=NULL,
@station char(20)=NULL OUTPUT,
@passfail char(1) =NULL OUTPUT,
@result char(20)=NULL OUTPUT

 AS
set nocount on

declare @lasttlid int

set @result = 'Null Parameters'

if (@acsserial is not null) and (@subtest_name is not null) --check for null parameters
begin
  --check for the last Test_ID
  select @lasttlid = max(TL_ID) 
  from testlog 
  where Test_ID in 
  ( -- retrieve all single Test_ID of a specific subtest_name
    select distinct Test_ID 
    from subtestlog 
    where Acs_Serial=@acsserial and subtest_name=@subtest_name
  )

  if @lasttlid is not null  --check if tested
  begin -- retrive the complete test result and station name associated to the subtestname
    select @station = station, @passfail = pass_fail from testlog where tl_id = @lasttlid
    set @result = 'OK Tested'
  end
  else
  begin --d is not test
    set @result = 'Not Tested'
  end
end

--select @acsserial as serial, @station as station, @passfail as passfail, @result as result
GO