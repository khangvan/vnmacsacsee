SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_GetAllModels]
@testname char(20)
AS
set nocount on

select distinct rtrim(SAP_Model_Name) as SAP_Model_Name
from subtestlimits where Station_Name = @testname
order by rtrim(SAP_Model_Name)
GO