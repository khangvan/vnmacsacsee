SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_AddsubtestToAllModels]
@station char(20),
@subtest char(20)
 AS
set nocount on

declare @next_model char(20)

declare cur_Models  cursor for 
select distinct sap_model_name from subtestlimits where station_name=@station
and sap_model_name not in (
select sap_model_name from subtestlimits where station_name = @station
and subtest_name=@subtest
)



open cur_Models

Fetch Next from cur_Models into @next_model

while @@Fetch_Status = 0
begin
insert into subtestlimits
(
Station_Name, SubTest_Name, SAP_Model_Name,
 Limit_Type, UL, LL, strLimit, 
flgLimit, Units, Description, 
Author, ACSEEMode, SPCParm, Hard_UL, 
Hard_LL, Limit_Date, ProductGroup_Mask, 
 Note_ID, OpportunitiesforFail
)
select top 1 
Station_Name, SubTest_Name, @next_model,
 Limit_Type, UL, LL, strLimit, 
flgLimit, Units, Description, 
Author, ACSEEMode, SPCParm, Hard_UL, 
Hard_LL, Limit_Date, ProductGroup_Mask, 
 Note_ID, OpportunitiesforFail
from subtestlimits where station_name = @station
and subtest_name=@subtest

   Fetch Next from cur_Models into @next_model
end

close cur_Models
Deallocate cur_Models
GO