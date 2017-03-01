SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TM_Previous_Test_Verification_New]
@acsserial char(20),
@subtest_name char(30)

 AS
set nocount on

declare @lasttlid int
declare @passfail char(3)

if (@acsserial is not null) and (@subtest_name is not null) --check for null parameters
begin
  --check for the last Test_ID
  select @lasttlid = max(TL_ID) 
  from testlog 
  where Test_ID in 
  ( -- retrieve all single Test_ID of a specific subtest_name
    select distinct Test_ID 
    from subtestlog 
    where Acs_Serial=@acsserial and substring(subtest_name,1,7)=substring(@subtest_name,1,7)
  )

  if @lasttlid is not null  --check if tested
  begin -- retrive the complete test result and station name associated to the subtestname
    select @passfail = pass_fail from testlog where tl_id = @lasttlid
    if (@passfail='P')
	begin
		return 2 -- means return pass
	end
	else
	begin
		return 1 -- means tested fail
	end
  end
  else
  begin --d is not test
    return 0 --means Not Tested
  end
end
GO