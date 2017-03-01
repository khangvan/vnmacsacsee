SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_GetDistinctModelsForTestAdvanced]
@testname char(20),
@user char(50)
 AS
set nocount on
select distinct SAP_Model_Name from Subtestlimits where Station_Name = @testname
and subtest_name in ( select subtest_name from subtestlimitsselect where acsUser = @user )
order by SAP_Model_Name
GO