SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_ONESapCopyParts]
 AS
set nocount on

/*
declare cur_newParts CURSOR for
select 
OneSapTranslate_ID, OneSapOldPart, OneSapNewPart, OneSapNewPartDescription
from onesapparttranslate

*/

declare cur_allParts  CURSOR FOR 
select part_no,station, menu, automatic, get_serial, disp_order, fill_quantity,
part_no_name, catalog.description, catalog.status, catalog.factorygroup_mask, catalog.productgroup_mask,
station_name, stations.description as stationdescription,pl_id from partlist
inner join catalog on part_no = part_no_count
inner join stations on station = station_count


declare @partno int
declare @station int
declare @menu char(1)
declare @automatic char(1)
declare @getserial char(5)
declare @disporder int
declare @fill_quantity int
declare @partnoname char(20)
declare @partdescription char(40)
declare @status char(1)
declare @factorygroupmask int
declare @productgroupmask int
declare @stationname char(20)
declare @stationdescription char(40)


declare @newpartnoname char(20)
declare @newpartdescription char(40)

declare @counter int

declare @pcount int
declare @lastidentity int

declare @scount int

declare @onesaptranslateid int

declare @totalrows int
declare @newcatalogcount int
declare @newpartlistcount int

declare @plid int 

set @totalrows = 0
set @newcatalogcount = 0
set @newpartlistcount = 0

/*

open  cur_newParts 
fetch next from  cur_newParts  into @onesaptranslateid, @partnoname, @newpartnoname, @newpartdescription
WHILE @@FETCH_STATUS = 0
begin

 if @newpartnoname is not null
begin

	if not exists(select Status from Catalog 
		where Part_No_Name=@newpartnoname)
	   begin

Begin transaction
		-- Increment Counter for Prot_No_Count in the Counters db
		exec ame_get_next_counter '5',@pcount OUTPUT -- Last_Part_No_Count
		if @pcount is NULL
		   Begin
			raiserror('E101.3 Serious error. Failed to update Counters db',17,1)
			Rollback Transaction
			return
		   End

		-- Save record to Catalog db
		Insert Catalog
                           (
                                     part_no_count,
                                     part_no_name,
                                     description,
                                     Status,
                                     factorygroup_mask,
                                     productgroup_mask
                           )
		Values (@pcount, @newpartnoname, @newpartdescription, 'A',256,256)
		if @@ERROR <> 0
		   Begin
			raiserror('E101.4 Serious error. Failed to append to Catalog db',17,1)
			Rollback Transaction
			Return
		   End
	
    --                         select @lastidentity = @@identity

                             insert into onesapcatalog_tracker
                             (
                                        onesapcatalog_part_no,
                                        onesapcatalog_partname
                              )
                             values
                              (
                                       @pcount,
                                        @newpartnoname
                              )
	--Commit T-SQL Transaction
	Commit Transaction

	   end



end

fetch next from  cur_newParts  into @onesaptranslateid, @partnoname, @newpartnoname, @newpartdescription
end

close cur_newParts
deallocate cur_newParts 

*/


set @counter = 0


open cur_allParts
fetch next from cur_allParts into @partno, @station, @menu, @automatic, @getserial, @disporder, @fill_quantity, @partnoname, @partdescription, @status, @factorygroupmask, @productgroupmask, @stationname, @stationdescription,@plid

WHILE ( @@FETCH_STATUS = 0 ) -- and  ( @counter < 5 )
BEGIN
print @partnoname
set @newpartnoname = null
set @newpartdescription = ''
select @newpartnoname = onesapnewpart , @newpartdescription =onesapnewpartdescription  from onesapparttranslate where onesapoldpart = @partnoname
print @newpartnoname
print @newpartdescription
print ''
print ' -------------------------------------------------------'

set @totalrows = @totalrows + 1
 if @newpartnoname is not null
begin
print 'newpart is not null'
             if rtrim(@newpartnoname) != rtrim(@partnoname)
             begin
print 'parts not equal'
	if not exists(select Status from Catalog 
		where Part_No_Name=@newpartnoname)
	   begin

Begin transaction
		-- Increment Counter for Prot_No_Count in the Counters db
		exec ame_get_next_counter '5',@pcount OUTPUT -- Last_Part_No_Count
		if @pcount is NULL
		   Begin
			raiserror('E101.3 Serious error. Failed to update Counters db',17,1)
			Rollback Transaction
			return
		   End

		-- Save record to Catalog db
		Insert Catalog
                           (
                                     part_no_count,
                                     part_no_name,
                                     description,
                                     Status,
                                     factorygroup_mask,
                                     productgroup_mask
                           )
		Values (@pcount, @newpartnoname, @newpartdescription, 'A',256,256)
		if @@ERROR <> 0
		   Begin
			raiserror('E101.4 Serious error. Failed to append to Catalog db',17,1)
			Rollback Transaction
			Return
		   End
	
  --                           select @lastidentity = @@identity
                             set @newcatalogcount = @newcatalogcount + 1
                             insert into onesapcatalog_tracker
                             (
                                        onesapcatalog_part_no,
                                        onesapcatalog_partname,
			OneSapCatalog_OldPartName,
                                        OneSapCatalog_OldPartDescription,
                                        OneSapCatalog_NewPartDescription,
                                        OneSapCatalog_AddDate
                              )
                             values
                              (
                                       @pcount,
                                        @newpartnoname,
			@partnoname,
                                        @stationdescription,
                                        @newpartdescription,
                                         getdate()
                              )
	--Commit T-SQL Transaction
	Commit Transaction

	   end     --	if not exists(select Status from Catalog where Part_No_Name=@newpartnoname)

          end     --  if rtrim(@newpartnoname) != rtrim(@partnoname)

end  -- if @newpartnoname is not null


--exec.ame_create_part
-- Define input parameters
--	@pname 	char(20) = NULL

--exec ame_create_part_control
-- Define input parameters
--	@pname 		char(20) = NULL, @sname	char(20) = NULL,
--	@menu		char(1) = NULL,  @auto	char(1) = NULL,
--	@gets		char(1) = NULL,  @dispo int = 1,
--	@fillq		int = 1

if @newpartnoname is not null
begin
             if rtrim(@newpartnoname) != rtrim(@partnoname)
             begin
print 'newpart not equals oldpart'
	select @scount=Station_Count from Stations
		where Station_Name=@stationname and Status='A'

	select @pcount=Part_No_Count from Catalog
		where Part_No_Name=@newpartnoname and Status='A'

print 'going to add partlist record'
print @pcount
print 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
             if @scount is not null and @pcount is not null
             begin
--             if not exists ( select part_no from partlist where part_no = @pcount and station = @scount)
--             begin

	Begin Transaction
		--Save new Partlist db record
		Insert Partlist
		Values(@pcount, @scount,@menu, @automatic, @getserial,@disporder,@fill_quantity)
		if @@ERROR <> 0
		   begin
			raiserror('E107.8 Serious Error. Failed to append record to Partlist db',17,1)
			Rollback Transaction
			return
		   end

	select @lastidentity = @@identity
              insert into OneSAPPartList_Tracker
              (
                    onesappartlist_pl_id,
                    onesappartlist_newpartname,
                    onesappartlist_oldpartname,
                    onesappartlist_station,
                    onesappartlist_adddate
              )
              values
               (
                    @lastidentity,
                     @newpartnoname,
                     @partnoname,
                     @stationname,
                     getdate()
               )

insert into onesapplid_record
(
plid_found
)
values
(
@plid
)
             set @counter = @counter + 1
	--Commit T-SQL transaction
              set @newpartlistcount = @newpartlistcount + 1
	Commit Transaction
--            end
            end  -- if @scount is not null and @pcount is not null
	end  --  if rtrim(@newpartnoname) != rtrim(@partnoname)
end  -- if @newpartnoname is not null




print 'totalrows'
print @totalrows
print 'newcatalogcount'
print @newcatalogcount 
print 'newpartlistcount'
print @newpartlistcount




fetch next from cur_allParts into @partno, @station, @menu, @automatic, @getserial, @disporder, @fill_quantity, @partnoname, @partdescription, @status, @factorygroupmask, @productgroupmask, @stationname, @stationdescription,@plid

END    --WHILE ( @@FETCH_STATUS = 0 ) and  ( @counter < 5 )

print 'totalrows'
print @totalrows
print 'newcatalogcount'
print @newcatalogcount 
print 'newpartlistcount'
print @newpartlistcount

close cur_allParts
deallocate cur_allParts
GO