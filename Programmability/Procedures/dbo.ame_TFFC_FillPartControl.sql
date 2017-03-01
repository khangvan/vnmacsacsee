SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_FillPartControl]
 AS
set nocount on

declare cur_PartStation CURSOR for
select 
TFFC_Part_No_Name, TFFC_Part_Description, TFFC_Part_Status,
 TFFC_Part_FactoryGroup_Mask, TFFC_Part_ProductGroup_Mask, 
TFFC_Station_Name, TFFC_Station_Description, TFFC_Menu, 
TFFC_Automatic, TFFC_Get_Serial, TFFC_Disp_Order, 
TFFC_Fill_Quantity
from TFFC_Record_PartControl

declare @part_no_name char(20)
declare @partdescription char(40)
declare @partstatus char(1)
declare @partfactorygroup int
declare @partproductgroup int
declare @stationname char(20)
declare @stationdescription char(40)
declare @menu char(1)
declare @automatic char(1)
declare @getserial char(5)
declare @disporder int
declare @fillquantity int

declare @counter int

declare @vnmstationname char(20)


set @counter = 0
open cur_PartStation

FETCH NEXT from cur_PartStation into 
@part_no_name,
@partdescription,
@partstatus,
@partfactorygroup,
@partproductgroup,
@stationname,
@stationdescription,
@menu,
@automatic,
@getserial,
@disporder,
 @fillquantity 


WHILE @@FETCH_STATUS = 0
begin

if not exists ( select pl_id from partlist  inner join stations on station = station_count
inner join catalog on part_no = part_no_count
where station_name = @stationname and part_no_name=@part_no_name )
begin

   if not exists ( select part_no_count from catalog where part_no_name=@part_no_name )
   begin
       exec ame_create_part @part_no_name
   end

   set @counter = @counter + 1
   if @stationname = 'ACSSKONESTART'
   begin
       set @vnmstationname = 'ACSVNONESTART'
   end


   if @stationname = 'ACSSKONELABEL'
   begin
       set @vnmstationname = 'ACSVNONELABEL'
   end


   if @stationname = 'ACSSKONEBOX'
   begin
       set @vnmstationname = 'ACSVNONEBOX'
   end


   exec ame_create_part_control @part_no_name, @vnmstationname,@menu, @automatic, @getserial,@disporder, @fillquantity

  print @counter
   print '---------'

end

FETCH NEXT from cur_PartStation into 
@part_no_name,
@partdescription,
@partstatus,
@partfactorygroup,
@partproductgroup,
@stationname,
@stationdescription,
@menu,
@automatic,
@getserial,
@disporder,
 @fillquantity 

end

close cur_PartStation
deallocate cur_PartStation
GO