SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_move_controlled_parts]
@strSourceStation char(20),
@strDestinationStation char(20),
@iMoveParts int,
@iDeleteDestFirst int
 AS

set nocount on

declare @iSourceStation int
declare @iDestinationStation int

select @iSourceStation = station_count from Stations where station_name = @strSourceStation


select @iDestinationStation = station_count from Stations where station_name = @strDestinationStation

if ( @iSourceStation is not null and  @iDestinationStation is not null )
begin
   if @iDeleteDestFirst = 1
   begin
      delete from partlist where station = @iDestinationStation
   end

   insert into partlist
   (
      part_no, station, menu,automatic, get_serial, disp_order,fill_quantity
   )
   select part_no, @iDestinationStation, menu,automatic, get_serial, disp_order, fill_quantity
   from partlist where station =@iSourceStation

   if @iMoveParts = 1
   begin
      delete from partlist where station = @iSourceStation
   end

   select 'OK'
end
else
begin
   select 'Source or Destination Not Found'
end
GO