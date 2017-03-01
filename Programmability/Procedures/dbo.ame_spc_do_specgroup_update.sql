SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE  procedure [dbo].[ame_spc_do_specgroup_update]
as
declare @stationName char(20)
declare @subtestName char(20)
declare @modelName char(20)
declare @ul float
declare @ll float
declare @samplesize int


--  table 0 holds distinct station names
create table #spc0 (
	station_name char(20)
)
--  table 1 holds inner join of stations and subtestlog 
--(ie new/current specgroups (prior to being assigned a 
--specgroup_id))
create table #spc1 (
	tmpIndx int identity(1,1),
	station_name char(20),
	test_name char(20),
	subtest_name char(20),
	model_name char(20),
	UL float,
	ll float,
	limit_id int
)
--  table 3 holds inner join of spcspecgroups and 
--spcspecmembers (old/current specgroups)
create table #spc3 (
	specgroup_id int,
	station_name char(20),
	subtest_name char(20),
	UL float,
	ll float,
	model_name char(20),
	samplesize int
)
--  table 4 holds the models to be deleted from the tables
create table #spc4 (
	specgroup_id int,
	station char(20),
	subtest char(20),
	model char(20),
	ul float,
	ll float,
	SampleSize int
)
--  table 5 holds the models to be added to the tables 
--(holds some that shouldn't be added, because they already 
--exist).
create table #spc5 (
	specgroup_id int,
	station char(20),
	subtest char(20),
	model char(20),
	ul float,
	ll float,
	SampleSize int
)

insert into #spc0
select distinct station_name from stations where stations.Perform_Test='Y' 
--perform inner join of stations and subtestlimts to get new/current groups
insert into #spc1
select #spc0.station_name,  subtestlimits.station_name, 
	subtestlimits.subtest_name, subtestlimits.sap_model_name, 
	subtestlimits.UL, subtestlimits.LL,  
	subtestlimits.Limit_id from #spc0 
	inner join subtestlimits on #spc0.station_name like (rtrim(subtestlimits.station_name) + '%' )
	where ascii(substring(#spc0.station_name,len(#spc0.station_name),1))<58 and
	subtestlimits.spcparm='y' and
	subtestlimits.ACSEEMode=0 and 
	subtestlimits.UL is not null and 
	subtestlimits.LL is not null 
--perform inner join of spcspecgroups and spcspecmembers to get old/curren groups
insert into #spc3
select spcspecgroups.specgroup_id, spcspecgroups.station_name, 
	spcspecgroups.subtest_name, UL, LL, spcspecmembers.sap_model_name, 
	spcspecgroups.samplesize 
	from spcspecgroups inner join spcspecmembers 
	on spcspecgroups.specgroup_id=spcspecmembers.specgroup_id 
	order by spcspecgroups.station_name, spcspecgroups.subtest_name, 
	spcspecgroups.UL,spcspecgroups.LL
--perform outer join of old/current and new/current to get old models
insert into #spc4
select  #spc3.specgroup_id, #spc3.station_name, 
	#spc3.subtest_name, #spc3.model_name, 
	#spc3.ul, #spc3.ll, #spc3.samplesize
	from #spc1 right outer join #spc3 on
	#spc1.station_name=#spc3.station_name and
	#spc1.subtest_name=#spc3.subtest_name and 
	#spc1.model_name=#spc3.model_name and
	#spc1.ul=#spc3.ul and
	#spc1.ll=#spc3.ll
	where #spc1.station_name is null
-- #spc4 now has the models to be deleted
--add altered specgroups to the temp add table
insert into #spc5
select  #spc3.specgroup_id, #spc3.station_name, 
	#spc3.subtest_name, #spc3.model_name, 
	#spc3.ul, #spc3.ll, #spc3.samplesize from #spc3
	where specgroup_id in (select specgroup_id from #spc4) and 
	model_name not in (select model from #spc4 where specgroup_id=specgroup_id)
--move old to groupstartLog
insert into SPCSpecGroupStartLog (specgroup_id, stl_id, spc_date)
	select specgroup_id, stl_id, spc_date from SPCSpecGroupStart
	where specgroup_id in (select specgroup_id from #spc4)
delete SPCSpecGroupStart
	where specgroup_id in (select specgroup_id from #spc4)
--move old to membersLog
insert into SPCSpecMembersLog (specgroup_id, sap_model_name, spcsgs_date)
	select specgroup_id, sap_model_name, spcsgs_date from SPCSpecMembers
	where specgroup_id in (select specgroup_id from #spc4)
delete SPCSpecMembers 
	where specgroup_id in (select specgroup_id from #spc4)
--move old to groupsLog
insert into SPCSpecGroupsLog (specgroup_id, station_name, subtest_name, ul, ll, samplesize)
	select specgroup_id, station_name, subtest_name, ul, ll, samplesize from SPCSpecGroups
	where specgroup_id in (select specgroup_id from #spc4)
delete SPCSpecGroups
	where specgroup_id in (select specgroup_id from #spc4)

--addition
--perform outer join of new/current and old/current to get new models
insert into #spc5
select 0, #spc1.station_name, #spc1.subtest_name, #spc1.model_name, 
	#spc1.UL, #spc1.LL,0
	from #spc1 left outer join #spc3 on
	#spc1.station_name=#spc3.station_name and
	#spc1.subtest_name=#spc3.subtest_name and 
	#spc1.model_name=#spc3.model_name and
	#spc1.ul=#spc3.ul and
	#spc1.ll=#spc3.ll 
	where specgroup_id is null
--eliminate any SampleSizes that are too big or small
update #spc5 set samplesize=4 
		where samplesize < 2
update #spc5 set samplesize=25 
		where samplesize > 25
--  cursor to go through new models in order to ensure 
--that the samplesize are the same for the specgroups.
declare c1 cursor
for select distinct station, subtest,  ul, ll from #spc5
open c1
fetch next from c1
into @stationName, @subtestName,  @ul, @ll
while @@FETCH_STATUS = 0
begin
	--  save the largest samplesize for a spec group (possible 
	--to have different sizes for different models, this is to 
	--eliminate that)
	set @samplesize = (select top 1 samplesize from #spc5 
		where subtest=@subtestName and 
		station=@stationName and ul=@ul 
		and ll=@ll order by SampleSize desc)
	--  set all the samplesizes the same for the specgroup
	update #spc5 set samplesize=@samplesize 
		where subtest=@subtestName and 
		station=@stationName and ul=@ul 
		and ll=@ll 
	fetch next from c1
	into @stationName, @subtestName, @ul, @ll
end
close c1
deallocate c1

--  Add new/changed specgroups into the SPCSpecgroup table.
--Is complicated (where, subqueries) so as to not add 
--specgroups that are already in the SPCSpecGroup table.
insert into SPCSpecgroups
select distinct station, subtest,  ul, ll, samplesize from #spc5
	where #spc5.station not in (select station_name from SPCSpecgroups where 	subtest_name=#spc5.subtest and ul=#spc5.ul and ll=#spc5.ll) and
	#spc5.subtest not in (select station_name from SPCSpecgroups where station_name=#spc5.station and 
	ul=#spc5.ul and ll=#spc5.ll) and
	#spc5.ul not in (select ul from SPCSpecgroups where subtest_name=#spc5.subtest and 
	station_name=#spc5.station and ll=#spc5.ll) and
	#spc5.ll not in (select ll from SPCSpecgroups where subtest_name=#spc5.subtest and 
	station_name=#spc5.station and ul=#spc5.ul)

--add to the spcspecmembers table.
insert into SPCSpecMembers
select SPCSpecgroups.specgroup_id, #spc5.model, GETDATE() from #spc5 
	inner join SPCSpecGroups on
	#spc5.station=SPCSpecGroups.station_name and
	#spc5.subtest=SPCSpecGroups.subtest_name and
	#spc5.ul=SPCSpecGroups.ul and
	#spc5.ll=SPCSpecGroups.ll

--recreating SPCMaps table
delete SPCMaps
insert into SPCMaps
select limit_id, specgroup_id from #spc1 inner join SPCspecGRoups on 
	#spc1.station_name=Spcspecgroups.station_name and 
	#spc1.subtest_name=spcspecgroups.subtest_name and 
	#spc1.ul=spcspecgroups.ul and #spc1.ll=spcspecgroups.ll

drop table #spc0
drop table #spc1
drop table #spc3
drop table #spc4
drop table #spc5
GO