SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_GetJustSubtests]
@testname char(20)
 AS
set nocount on


select v.Station_name, v.Subtest_name, v.Limit_Type, isnull(v.LL,0.0) as LL, isnull(v.UL,0.0) as UL, v.strLimit,
 isnull(v.Hard_LL,0.0) as Hard_LL, isnull(v.Hard_UL,0.0) as Hard_UL,v.num,v.Units, v.flgLimit,v.Description, v.ACSEEMode, v.SPCParm
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
order by v.Subtest_name, v.num desc
GO