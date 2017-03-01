SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE  procedure [dbo].[ame_spc_get_good_specgroup_data]
	@sap_model_name char(20),
	@subtest_name char(20),
	@test_name char(20)
	--@specgroup_id int
as

set nocount on
create table #specgroup(
	sg_id int
)
insert into #specgroup
exec ame_spc_get_specgroupID @sap_model_name, @subtest_name , @test_name

create table #exceltmp(
	model_name char(20),
	floatValue float,
	intValue int,
	stl_id int,
	test_date_time smalldatetime
)

insert into #exceltmp
select top 650 testlog.sap_model, subtestlog.floatValue, subtestlog.intValue, subtestlog.stl_id, testlog.test_date_time
from testlog inner join subtestlog on subtestlog.test_id=testlog.test_id 
		--and subtestlog.station=testlog.station
where testlog.sap_model in(select sap_model_name from spcspecmembers where specgroup_ID in(select sg_id from #specgroup))
	and subtestlog.subtest_name=@subtest_name
	and subtestlog.pass_fail='P'
	and testlog.pass_fail='P'
order by testlog.tl_id desc

/*insert into #exceltmp
select top 650 testlog.sap_model, subtestlog.floatValue, subtestlog.intValue, subtestlog.stl_id, testlog.test_date_time
from (subtestlimits inner join testlog on testlog.sap_model=subtestlimits.sap_model_name and testlog.station=subtestlimits.station_name)
	inner join subtestlog on subtestlog.subtest_name=subtestlimits.subtest_name 
		and subtestlog.test_id=testlog.test_id 
		and subtestlog.station=testlog.station
where testlog.sap_model in(select sap_model_name from spcspecmembers where specgroup_ID in(select sg_id from #specgroup))
	and subtestlimits.subtest_name in (select subtest_name from spcspecgroups where specgroup_id in(select sg_id from #specgroup))
	and subtestlog.pass_fail='P'
order by testlog.tl_id desc*/

select * from #exceltmp order by stl_id asc

drop table #exceltmp
drop table #specgroup
GO