SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_CloneSubtestLimits]
@testname char(20),
@sourcetestname char(20),
@newauthor char(25),
@retcode int OUTPUT
 AS
set nocount on
declare @numfound int
declare @newStation_Name char(20)
declare	@Station_Name 	char(20) 
declare	@Subtest_Name char(20)
declare		@SAP_Model_Name char(20)
declare	             @Limit_Type char(1)
declare	             @UL  real
declare	             @LL real
declare	             @strLimit char(40)
 declare	            @flgLimit char(1)
 declare	            @Units char(10)
declare	             @Description char(50)
declare	             @Author char(25)
declare	             @ACSEEMode int
declare	             @SPCParm char(1)
declare	             @Hard_UL real
declare	             @Hard_LL real
declare	             @Limit_Date datetime
declare	             @ProductGroup_mask int 



declare cur_SourceTest CURSOR FOR
select 
Station_Name,
Subtest_Name,
SAP_Model_Name,
Limit_Type,
UL,
LL,
strLimit,
flgLimit,
Units,
Description,
ACSEEMode,
SPCParm,
Hard_UL,
Hard_LL,
ProductGroup_Mask
from subtestlimits
where station_Name = @sourcetestname




set @retcode = 0


open cur_SourceTest

set @newStation_Name = @testname

FETCH NEXT from cur_SourceTest
INTO
@Station_name,
@subtest_name,
@SAP_Model_Name,
@Limit_Type,
@UL,
@LL,
@strLimit,
@flgLimit,
@Units,
@Description,
@ACSEEMode,
@SPCParm,
@Hard_UL,
@Hard_LL,
@ProductGroup_Mask
if @@ERROR <>0
begin
  set @retcode = 1
end


while @@FETCH_STATUS = 0
Begin



insert into subtestlimits
(
Station_Name,
Subtest_Name,
SAP_Model_Name,
Limit_Type,
UL,
LL,
strLimit,
flgLimit,
Units,
Description,
Author,
ACSEEMode,
SPCParm,
Hard_UL,
Hard_LL,
Limit_Date,
ProductGroup_Mask
)
values
(
@newstation_name,
@subtest_name,
@SAP_Model_Name,
@Limit_Type,
@UL,
@LL,
@strLimit,
@flgLimit,
@Units,
@Description,
@newauthor,
@ACSEEMode,
@SPCParm,
@Hard_UL,
@Hard_LL,
getdate(),
@ProductGroup_Mask
)
if @@ERROR <>0
begin
  set @retcode = 2
end



FETCH NEXT from cur_SourceTest
INTO
@Station_name,
@subtest_name,
@SAP_Model_Name,
@Limit_Type,
@UL,
@LL,
@strLimit,
@flgLimit,
@Units,
@Description,
@ACSEEMode,
@SPCParm,
@Hard_UL,
@Hard_LL,
@ProductGroup_Mask
End

close cur_SourceTest
deallocate cur_SourceTest
GO