SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getMachineSAPLocation]
@mname  char(30)
 AS
set nocount on
if (substring(@mname,1,2) = 'F4') or ( substring(@mname,1,6)='FALCON') or ( substring(@mname,1,3)='P40') or ( substring(@mname,1,4)='DCLA') or  ( substring(@mname,1,9) = 'RHINODIGA') or ( substring(@mname,1,2) = 'VN')
begin
if exists ( select SAPLocationIndex from Stations where machine_name = @mname )
begin
select SAPLocationIndex, SAPLocationName,BOMEndPoint, BOMWerks   from Stations where machine_name = @mname
end
else
begin
select 0 as SAPLocationIndex, 'PRD' as SAPLocationName,  'http://home/SAPLINK/' as  BOMEndPoint, '3400' as  BOMWerks 
end
end
else
begin
if exists ( select SAPLocationIndex from Stations where station_name = @mname )
begin
select SAPLocationIndex, SAPLocationName,BOMEndPoint, BOMWerks  from Stations where station_name = @mname
end
else
begin
select 0 as SAPLocationIndex, 'PRD' as SAPLocationName,  'http://home/SAPLINK/' as  BOMEndPoint, '3400' as  BOMWerks 
end
end
GO