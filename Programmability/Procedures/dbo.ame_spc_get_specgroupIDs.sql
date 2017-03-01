SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_spc_get_specgroupIDs]
	@model_name char(20),
	@station_name char(20)
 AS
set nocount on

select SPCSpecGroups.subtest_name, SPCSpecGroups.SpecGroup_ID, SPCSpecGroups.ul, SPCSpecGroups.ll from SPCspecgroups
inner join SPCSpecMembers on SPCSpecGroups.specgroup_id=SPCSpecMembers.specgroup_id
where SPCSpecGroups.Station_name=@station_name and SPCSpecMembers.Sap_model_name=@model_name
GO