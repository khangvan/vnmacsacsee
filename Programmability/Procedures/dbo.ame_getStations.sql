SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getStations] AS
set nocount on

select station_name, station_count,Status from Stations
order by station_name
GO