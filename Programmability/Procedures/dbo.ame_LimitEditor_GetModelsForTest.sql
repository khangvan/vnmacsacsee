SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_GetModelsForTest]
@testname char(20)
 AS
set nocount on
select distinct SAP_Model_Name from Subtestlimits where Station_Name = @testname
order by SAP_Model_Name
GO