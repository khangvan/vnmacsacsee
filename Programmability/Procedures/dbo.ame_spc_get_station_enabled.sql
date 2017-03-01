SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[ame_spc_get_station_enabled]
	@station_name char(20)
as
select SPCEnabled from stations where station_name=@station_name
GO