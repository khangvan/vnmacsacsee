SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_FullBuildLimitsOfInterest] 
@user char(50),
@subtest_name char(20),
@type char(1),
@acseemode int,
@Station_Name char(20), 
@SAP_Model_Name char(20), 
@UL float(53), 
@LL float(53), 
@strLimit char(40), 
@flgLimit char(1), 
@Units char(10), 
@Description char(40), 
@SPCParm char(1), 
@Hard_UL float(53),
@Hard_LL float(53),  
@ProductGroup_Mask int

 AS
set nocount on
insert into subtestlimitsselect  (acsuser, 
Set_DateTime,  
SubTest_Name, 
Limit_Type, 
ACSEEMode,
Station_Name,
SAP_Model_Name,
UL,
LL,
strLimit,
flgLimit,
Units,
Description,
SPCParm,
Hard_UL,
Hard_LL,
ProductGroup_Mask
 )
values ( @user, 
getdate(), 
@subtest_name,
@type,
@acseemode,
@Station_Name,
@SAP_Model_Name,
@UL,
@LL,
@strLimit,
@flgLimit,
@Units,
@Description,
@SPCParm,
@Hard_UL,
@Hard_LL,
@ProductGroup_Mask)
GO