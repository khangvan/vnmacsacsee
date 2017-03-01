SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_UpdateLimitFromSubtest] 
@user char(50),
@station char(20),
@model char(20)
AS
set nocount on
--delete from subtestlimits where sap_model_name = @model and subtest_name in
--(select subtest_name from subtestlimitsselect where acsuser =@user )


declare @Limit_Type char(1)
declare @UL real
declare @LL real
declare @strLimit char(40)
declare @flgLimit char(1)
declare @Units char(10)
declare  @Description char(50)
declare @Author char(25)
declare  @ACSEEMode int
declare  @SPCParm char(1)
declare @Hard_UL real
declare  @Hard_LL real
declare  @Limit_Date datetime
declare  @ProductGroup_mask int


declare @currentdt datetime

declare @subtest_name char(20)
declare @retcode int


declare cur_Limits CURSOR FOR
 select subtest_name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL, ProductGroup_Mask
 from subtestlimitsselect where acsuser = @user


open cur_Limits
FETCH NEXT FROM cur_Limits into @subtest_name, @Limit_Type, @UL, @LL, @strLimit, @flgLimit, @Units, @Description, @Author, @ACSEEMode, @SPCParm,
@Hard_UL, @Hard_LL, @ProductGroup_mask

WHILE @@FETCH_STATUS = 0 
begin


--exec ame_LimitEditor_Delete_limit
-- Define input parameters
--	@station,
--	@subtest_Name,
--	@model,
--             0,
--             @user,
--              @retcode  OUTPUT


set @currentdt = getdate()
exec ame_LimitEditor_AddUpdate_limit
	@station,
	@subtest_name ,
	@model,
             @Limit_Type,
             @UL,
             @LL,
             @strLimit ,
             @flgLimit ,
             @Units ,
             @Description ,
             @user ,
             @ACSEEMode,
             @SPCParm ,
             @Hard_UL ,
             @Hard_LL ,
             @currentdt ,
             @ProductGroup_mask,
             @retcode  OUTPUT

FETCH NEXT FROM cur_Limits into @subtest_name, @Limit_Type, @UL, @LL, @strLimit, @flgLimit, @Units, @Description, @Author, @ACSEEMode, @SPCParm,
@Hard_UL, @Hard_LL, @ProductGroup_mask
end

close cur_Limits
deallocate cur_Limits
GO