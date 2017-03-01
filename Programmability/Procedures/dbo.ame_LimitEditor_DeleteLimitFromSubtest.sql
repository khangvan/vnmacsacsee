SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_DeleteLimitFromSubtest] 
@user char(50),
@station char(20),
@model char(20)
AS
set nocount on
--delete from subtestlimits where sap_model_name = @model and subtest_name in
--(select subtest_name from subtestlimitsselect where acsuser =@user )

declare @subtest_name char(20)
declare @retcode int


declare cur_Limits CURSOR FOR
 select subtest_name from subtestlimitsselect where acsuser = @user


open cur_Limits
FETCH NEXT FROM cur_Limits into @subtest_name

WHILE @@FETCH_STATUS = 0 
begin


exec ame_LimitEditor_Delete_limit
-- Define input parameters
	@station,
	@subtest_Name,
	@model,
             0,
             @user,
              @retcode  OUTPUT


FETCH NEXT FROM cur_Limits into @subtest_name
end

close cur_Limits
deallocate cur_Limits
GO