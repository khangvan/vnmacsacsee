SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_loadROHSLimitsmappings]
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

declare cur_GetParts CURSOR FOR
select distinct old_part_no_name, new_part_no_name, station_name,
subtest_name, limit_type, UL, LL, strLimit,flgLimit,
Units,Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL,
Limit_Date,ProductGroup_Mask
 from subtestlimits
inner join ROHSPartMap on SAP_Model_Name = old_part_no_name



open cur_GetParts
fetch next from cur_GetParts into @oldpartname, @newpartname, 
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
where Station_name = @Station_name and Subtest_name = @Subtest_Name and SAP_Model_Name = @oldpartname and ACSEEMode = @ACSEEMode
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

fetch next from cur_GetParts into @oldpartname, @newpartname, @description, @status, @factorymask, @productmask, @rhosid
end

close cur_GetParts
deallocate cur_GetParts
GO