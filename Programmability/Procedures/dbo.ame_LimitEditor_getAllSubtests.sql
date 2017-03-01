SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_getAllSubtests]
@testname char(20)
 AS
set nocount on

select distinct subtest_name, Limit_Type, ACSEEMode
from subtestlimits where station_name = @testname
order by subtest_name, Limit_Type, ACSEEmode
GO