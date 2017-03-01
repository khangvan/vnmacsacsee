SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_GetExactSubtestLimits]
@testname char(20),
@model char(20)
 AS
set nocount on



select Station_name, Subtest_name, Limit_Type, LL, UL, strLimit,
 Hard_LL, Hard_UL,SAP_Model_Name,Units, flgLimit,Description, ACSEEMode, SPCParm
from  subtestlimits where
Station_Name = @testname
and SAP_Model_Name = @model
order by subtest_name
GO