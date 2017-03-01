SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_Stage_GetSrcLimitsModel]
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


select Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL,
 strLimit, flgLimit, Units, Description, Author, ACSEEMode, 
SPCParm, Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, 
Limit_ID, 
Note_ID, OpportunitiesforFail
from subtestlimits
where  sap_model_name = @model
order by SubTest_Name
GO