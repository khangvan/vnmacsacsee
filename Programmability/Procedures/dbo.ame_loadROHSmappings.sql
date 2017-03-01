SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_loadROHSmappings]
 AS
set nocount on

declare @oldpartname char(20)
declare @newpartname char(20)
declare @description char(40)
declare @status char(1)
declare @factorymask int
declare @productmask int
declare @rhosid int

declare @nextcounter int

declare @partnocount int

declare cur_GetParts CURSOR FOR
select distinct old_part_no_name, new_part_no_name, description,
status, factorygroup_mask, productgroup_mask,
id from partlist
inner join catalog on part_no = part_no_count
inner join ROHSPartMap on part_no_name = old_part_no_name
where new_part_no_name
not in
( select part_no_name from catalog) 

begin tran 
open cur_GetParts
fetch next from cur_GetParts into @oldpartname, @newpartname, @description, @status, @factorymask, @productmask, @rhosid

while @@fetch_status = 0
begin


print 'trying'
exec ame_get_next_counter 5, @nextcounter OUTPUT

print @nextcounter

   if @nextcounter is not null
   begin
      
print 'adding'

      insert into catalog
      ( 
        part_no_count,
        part_no_name,
        description,
        status,
        FactoryGroup_mask,
        ProductGroup_mask
      )
      values
      (
         @nextcounter,
          @newpartname,
           @description,
            @status,
             @factorymask,
              @productmask 
     )      


      select @partnocount = part_no_count from catalog where part_no_name = @oldpartname


      insert into partlist
      (  
          part_no,
          station,
          menu,
          automatic,
          get_serial,
          disp_order,
          fill_quantity
      )
      select
          @nextcounter,
          station,
          menu,
          automatic,
          get_serial,
          disp_order,
          fill_quantity
      from partlist
      where part_no = @partnocount

   end



fetch next from cur_GetParts into @oldpartname, @newpartname, @description, @status, @factorymask, @productmask, @rhosid
end

close cur_GetParts
deallocate cur_GetParts



     if @@error = 0
     begin 
commit  tran 
    end
    else
    begin

print 'roollled back'
      rollback tran 
    end
GO