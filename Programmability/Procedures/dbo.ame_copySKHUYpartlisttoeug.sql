SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_copySKHUYpartlisttoeug]
AS
declare cur_list  CURSOR FOR
select station_name, part_no_name, menu, automatic, get_serial,disp_order, fill_quantity from importpartlist

declare @station char(20)
declare @partname char(20)
declare @menu char(1)
declare @automatic char(1)
declare @getserial char(5)
declare @disporder int
declare @fillquantity int

open cur_list

FETCH NEXT from cur_list into @station, @partname, @menu, @automatic, @getserial, @disporder, @fillquantity
WHILE @@FETCH_STATUS = 0
begin
   if not exists ( select station_name from stations where station_name = @station)
   begin
      print 'station not found'
      print @station
   end
   if not exists ( select part_no_name from catalog where part_no_name = @partname )
   begin
      print 'part not found'
      print @partname
        exec ame_create_part @partname
   end
--if not exists ( select part_no from partlist
--inner join stations on station= station_count
--inner join catalog on part_no = part_no_count
--where station_name=@station and part_no_name=@partname )
--begin
exec ame_create_part_control	@partname, @station,@menu,  @automatic,@getserial,  @disporder,@fillquantity
--end
FETCH NEXT from cur_list into @station, @partname, @menu, @automatic, @getserial, @disporder, @fillquantity
end
close cur_list
deallocate cur_list
GO