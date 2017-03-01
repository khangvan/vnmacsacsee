SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[ame_spc_get_specgroup_samplesize]
	@specgroup_id int
as

select SampleSize from SPCSpecgroups where specgroup_id=@specgroup_id
GO