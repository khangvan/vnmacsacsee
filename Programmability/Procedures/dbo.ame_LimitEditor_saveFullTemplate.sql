SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_saveFullTemplate]
@Set_Name char(50), 
@Station_Name char(20), 
@SubTest_Name char(20), 
@Limit_Type char(1),
@UL float(53), 
@LL float(53), 
@strLimit char(40), 
@flgLimit char(1), 
@Units char(10), 
@Description char(50), 
@Author char(25), 
@ACSEEMode int, 
@SPCParm char(1), 
@Hard_UL float(53), 
@Hard_LL float(53),
@ProductGroup_mask int,
@return int OUTPUT

AS
set nocount on

insert into subtesttemplates
(
Set_Name, 
Set_DateTime, 
Station_Name, 
SubTest_Name, 
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
ProductGroup_Mask
)
values
(
@Set_Name,
getdate(),
@station_name,
@subtest_name,
@limit_type,
@UL,
@LL,
@strLimit,
@flgLimit,
@Units,
@Description,
@Author,
@ACSEEMode,
@SPCParm,
@Hard_UL,
@Hard_LL,
@ProductGroup_mask
)
GO