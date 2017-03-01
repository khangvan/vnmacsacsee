SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[ame_spc_put_specgroup_start]
	@specgroup_id int,
	@stl_id int
as
set nocount on


insert into SPCSpecgroupStart (specgroup_id,  STL_ID, spc_date) values (@specgroup_id,  @stl_id, GETDATE())
GO