﻿SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_GetAllModelsForTestAdvanced]
@testname char(20),
@user char(50)
 AS
set nocount on
select distinct SAP_Model_Name from Subtestlimits where Station_Name = @testname
order by SAP_Model_Name
GO