SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_GetSubtestLimits]
@testname char(20),
@model char(20)
 AS
set nocount on

/*
select Station_name, Subtest_name, Limit_Type, LL, UL, strLimit, Hard_LL, Hard_UL, count(*) as num
from subtestlimits where Station_name = @testname
group by 
Station_Name, Subtest_Name,  Limit_Type, LL, UL, strLimit, Hard_LL, Hard_UL
order by Subtest_name, num desc
*/


select v.Station_name, v.Subtest_name, v.Limit_Type, isnull(v.LL,0.0) as LL, isnull(v.UL,0.0) as UL, v.strLimit,
 isnull(v.Hard_LL,0.0) as Hard_LL, isnull(v.Hard_UL,0.0) as Hard_UL,v.num,SAP_Model_Name,v.Units,v.flgLimit,v.Description, v.ACSEEMode, v.SPCParm
from
(
select Station_name, Subtest_name, Limit_Type, LL, UL, strLimit, Hard_LL, Hard_UL, Units, flgLimit,Description, ACSEEMode, SPCParm, count(*) as num
from subtestlimits where Station_name = @testname
group by 
Station_Name, Subtest_Name,  Limit_Type, LL, UL, strLimit, Hard_LL, Hard_UL,Units, flgLimit,Description,ACSEEMode, SPCParm
) v
inner join subtestlimits on v.Station_name = subtestlimits.Station_Name
and v.Subtest_name = subtestlimits.Subtest_name
and isnull(v.LL,0) = isnull(subtestlimits.LL,0)
and isnull(v.UL,0) = isnull(subtestlimits.UL,0)
and isnull(v.strLimit,'') = isnull(subtestlimits.strLimit,'')
and isnull(v.Hard_LL,0) = isnull(subtestlimits.Hard_LL,0)
and isnull(v.Hard_UL,0) = isnull(subtestlimits.Hard_UL,0)
and isnull(v.Units,'') = isnull(subtestlimits.Units,'')
and isnull(v.flgLimit,'') = isnull(subtestlimits.flgLimit,'')
and isnull(v.Description,'') = isnull(subtestlimits.Description,'')
and isnull(v.Limit_Type,'') = isnull(subtestlimits.Limit_Type,'')
and isnull(v.SPCParm,'') = isnull(subtestlimits.SPCPArm,'')
order by v.Subtest_name, v.num desc , SAP_Model_name


select distinct SAP_Model_Name
from subtestlimits where Station_Name = @testname
order by SAP_Model_Name
GO