SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[ame_spc_get_specgroupID]
	@sap_model_name char(20),
	@subtest_name char(20),
	@station_name char(20)
as
set nocount on

select SPCSpecGroups.SpecGroup_ID from SPCspecgroups
inner join SPCSpecMembers on SPCSpecGroups.specgroup_id=SPCSpecMembers.specgroup_id
where SPCSpecGroups.Station_name=@station_name 
	and SPCSpecMembers.Sap_model_name=@sap_model_name 
	and SPCSpecGroups.subtest_name=@subtest_name
GO