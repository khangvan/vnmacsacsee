SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_AddPartsToStation]
 AS

declare cur_Parts CURSOR FOR
select partnumber from dpellparts


declare @partnum char(20)
declare @pcount int

open cur_Parts
FETCH NEXT from cur_Parts into @partnum

WHILE @@FETCH_STATUS=0
BEGIN

select @pcount = part_no_count from catalog where part_no_Name = @partnum

if @pcount is not null
begin

print 'adding' 
print @partnum
-- check and add to ACSBASEPACKAGE
   if not exists ( select Part_no from partlist where station =473 and part_no = @pcount )
   begin
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
     values
     (
       @pcount,
        473,
        null,
        'N',
        'N',
        95,
        1
     )
   end


-- check and add to ACSP2DPACKAGE

   if not exists ( select Part_no from partlist where station =367 and part_no = @pcount )
   begin
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
     values
     (
       @pcount,
        367,
        null,
        'N',
        'N',
        95,
        1
     )

   end

-- delete from 195 acseeful2
delete from partlist where part_no = @pcount and station = 195


--delete from 412 FUL3Label
delete from partlist where part_no = @pcount and station = 412


-- delete from 357 FUL2PACKAGE
delete from partlist where part_no = @pcount and station = 357


-- delete from 183 ACSEEFULRCSTART
delete from partlist where part_no = @pcount and station = 183


--delete from 179 ACSRCPACKAGE
delete from partlist where part_no = @pcount and station = 179


-- delete from 312 ACSPWPACKAGE
delete from partlist where part_no = @pcount and station = 312


end


FETCH NEXT from cur_Parts into @partnum
END

close cur_Parts
deallocate cur_Parts
GO