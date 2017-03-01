SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_checkIfPartControlled]
@station char(20),
@partname char(20)
 AS
set nocount on

declare @plid int



select @plid = pl_id from partlist
inner join catalog on part_no = part_no_count
inner join stations on station = station_count
where rtrim(station_name) = rtrim(@station)
and rtrim(part_no_name)=rtrim(@partname)

if @plid is null
begin
  Select 'NOTFOUND' as existtest
end
else
begin
   select 'EXISTS' as existtest
   select station_name, part_no_name, station, part_no, Menu, Automatic, Get_Serial, Disp_Order, Fill_Quantity, pl_id from partlist 
inner join catalog on part_no = part_no_count
inner join stations on station = station_count
where pl_id = @plid

end
GO