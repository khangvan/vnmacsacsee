SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getStationSAPLocation]
@sname  char(20)
 AS
set nocount on
if exists ( select SAPLocationIndex from Stations where station_name = @sname )
begin
select SAPLocationIndex from Stations where station_name = @sname
end
else
begin
select 0
end
GO