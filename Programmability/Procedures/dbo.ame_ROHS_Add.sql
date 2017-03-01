SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_ROHS_Add]
 AS
set nocount on


declare @oldpartname char(20)
declare @newpartname char(20)

declare @status char(1)
declare @factorymask int
declare @productmask int
declare @rhosid int



declare	@Station_Name 	char(20) 
declare	@Subtest_Name char(20)
declare	@SAP_Model_Name char(20)
declare  @Limit_Type char(1)
declare  @UL real
declare  @LL real
declare @strLimit char(40)
 declare             @flgLimit char(1)
declare              @Units char(10)
declare              @Description char(50)
declare              @Author char(25)
declare              @ACSEEMode int
declare              @SPCParm char(1)
declare              @Hard_UL real
declare              @Hard_LL real
declare              @Limit_Date datetime
declare              @ProductGroup_mask int

declare @retcode int


declare @nextcounter int

declare @partnocount int

declare cur_GetPartsLimits CURSOR FOR
select distinct PreROHS_Model, ROHS_Model, station_name,
subtest_name, limit_type, UL, LL, strLimit,flgLimit,
Units,Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL,
Limit_Date,ProductGroup_Mask
 from subtestlimits
inner join ROHS_NewOld_mappings on SAP_Model_Name = PreROHS_Model


declare cur_GetParts CURSOR FOR
select distinct PreROHS_Model, ROHS_Model, description,
status, factorygroup_mask, productgroup_mask from partlist
inner join catalog on part_no = part_no_count
inner join ROHS_NewOld_mappings on part_no_name = PreROHS_Model
where ROHS_Model
not in
( select part_no_name from catalog) 



open cur_GetPartsLimits
fetch next from cur_GetPartsLimits into @oldpartname, @newpartname, 
@Station_Name,
@Subtest_Name,
@Limit_Type,
@UL,
@LL,
@strLimit,
@flgLimit,
@Units,
@Description,
@Author,
@ACSEEMode,
@SPCParm,
@Hard_UL,
@Hard_LL,
@Limit_Date,
@ProductGroup_Mask

while @@fetch_status = 0
begin


print 'trying'

if not exists 
(
select distinct SAP_Model_Name
 from subtestlimits
where Station_name = @Station_name and Subtest_name = @Subtest_Name and SAP_Model_Name = @newpartname and ACSEEMode = @ACSEEMode
)
 begin     
print 'adding'

exec ame_LimitEditor_AddUpdate_limit
	@Station_Name ,
	@Subtest_Name ,
	@newpartname ,
             @Limit_Type,
             @UL,
             @LL,
             @strLimit,
             @flgLimit,
             @Units ,
             @Description ,
             @Author,
             @ACSEEMode ,
             @SPCParm ,
             @Hard_UL ,
             @Hard_LL ,
             @Limit_Date ,
             @ProductGroup_mask ,
             @retcode  OUTPUT





end

fetch next from cur_GetPartsLimits into @oldpartname, @newpartname, 
@Station_Name,
@Subtest_Name,
@Limit_Type,
@UL,
@LL,
@strLimit,
@flgLimit,
@Units,
@Description,
@Author,
@ACSEEMode,
@SPCParm,
@Hard_UL,
@Hard_LL,
@Limit_Date,
@ProductGroup_Mask
end

close cur_GetPartsLimits
deallocate cur_GetPartsLimits




begin tran 
open cur_GetParts
fetch next from cur_GetParts into @oldpartname, @newpartname, @description, @status, @factorymask, @productmask

while @@fetch_status = 0
begin


if not exists
(
select part_no_count from catalog where part_no_name = @newpartname
)
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

end

fetch next from cur_GetParts into @oldpartname, @newpartname, @description, @status, @factorymask, @productmask
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


--select ROHSMaterial, PreROHSMaterial, LO, MTYPE from ROHS_ExcelHoldingTable

--select ROHS_Model, PReROHS_Model,DateAdded, LO, MType from ROHS_NewOld_Mappings


select sap_model_name from subtestlimits
GO