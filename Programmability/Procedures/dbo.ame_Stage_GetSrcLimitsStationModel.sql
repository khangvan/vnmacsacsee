SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_Stage_GetSrcLimitsStationModel]
@station char(20),
@model char(20)
AS

set nocount on

declare  @Station_Name  char(20)
declare    @Subtest_Name char(20)
declare    @SAP_Model_Name char(20)
declare    @Limit_Type char(1)
declare    @UL  real
declare    @LL  real
declare    @strLimit char(40) 
declare    @flgLimit char(1)
declare    @Units char(10) 
declare    @Description char(50) 
declare    @Author  char(25)
declare    @ACSEEMode int
declare    @SPCParm  char(1)
declare    @Hard_UL  real
declare    @Hard_LL real
declare    @Limit_Date datetime 
declare    @ProductGroup_mask int
declare @noteid int
declare @oppsforfail int
/*
declare curSourceLimits CURSOR for
select Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL,
 strLimit, flgLimit, Units, Description, Author, ACSEEMode, 
SPCParm, Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, 
Limit_ID, 
Note_ID, OpportunitiesforFail
from subtestlimits
where station_name = @station and sap_model_name = @model


open curSourceLimits

FETCH NEXT from curSourceLimits INTO   @Station_Name, 
    @Subtest_Name ,
    @SAP_Model_Name ,
    @Limit_Type ,
    @UL ,
    @LL ,
    @strLimit, 
    @flgLimit ,
    @Units ,
    @Description ,
    @Author ,
    @ACSEEMode ,
    @SPCParm ,
    @Hard_UL ,
    @Hard_LL ,
    @Limit_Date ,
    @ProductGroup_mask 

WHILE @@FETCH_STATUS = 0
begin





FETCH NEXT from curSourceLimits INTO   @Station_Name, 
    @Subtest_Name ,
    @SAP_Model_Name ,
    @Limit_Type ,
    @UL ,
    @LL ,
    @strLimit, 
    @flgLimit ,
    @Units ,
    @Description ,
    @Author ,
    @ACSEEMode ,
    @SPCParm ,
    @Hard_UL ,
    @Hard_LL ,
    @Limit_Date ,
    @ProductGroup_mask 
end


close curSourceLimits
deallocate curSourceLimits
*/

select Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL,
 strLimit, flgLimit, Units, Description, Author, ACSEEMode, 
SPCParm, Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, 
Limit_ID, 
Note_ID, OpportunitiesforFail
from subtestlimits
where station_name = @station and sap_model_name = @model
order by SubTest_Name
GO