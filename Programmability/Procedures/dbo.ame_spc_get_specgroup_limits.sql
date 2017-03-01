SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_spc_get_specgroup_limits]
	@sg_id int
 AS
set nocount on
select  ul, ll from SPCSpecGroups
where specgroup_id=@sg_id
GO