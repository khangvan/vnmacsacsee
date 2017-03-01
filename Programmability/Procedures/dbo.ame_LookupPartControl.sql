SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LookupPartControl]
@partname char(20),
@station char(20) OUTPUT
 AS
set nocount on

declare @plid int



select @plid = pl_id from partlist
inner join catalog on part_no = part_no_count
where  rtrim(part_no_name)=rtrim(@partname)

if @plid is null
begin
  Select 'NOTFOUND' as existtest
end
else
begin
   select @station = station_name from partlist inner join stations on station = station_count where pl_id = @plid
   select 'EXISTS' as existtest
   select station_name, part_no_name, station, part_no, Menu, Automatic, Get_Serial, Disp_Order, Fill_Quantity, perform_test, pl_id from partlist 
inner join catalog on part_no = part_no_count
inner join stations on station = station_count
where  rtrim(part_no_name)=rtrim(@partname)

end
GO