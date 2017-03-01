SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_Stage_MoveModelLimit]
-- Define input parameters
	@Station_Name 	char(20) = NULL,
	@Subtest_Name char(20)=NULL,
	@SAP_Model_Name char(20)=NULL,
             @Limit_Type char(1),
             @UL real,
             @LL real,
             @strLimit char(40),
             @flgLimit char(1),
             @Units char(10),
             @Description char(50),
             @Author char(25),
             @ACSEEMode int,
             @SPCParm char(1),
             @Hard_UL real,
             @Hard_LL real,
             @Limit_Date datetime,
             @ProductGroup_mask int,
             @note char(2000),
             @oppsforfail int,
             @destStation_Name   char(20) = NULL,
              @username char(50),
             @retcode int OUTPUT

AS
set nocount on

declare @existcount int

set @retcode = 0

select @existcount = count(*) from subtestlimits where 
station_Name = @Station_name and
Subtest_Name = @Subtest_Name and
SAP_Model_Name = @SAP_Model_Name
and ACSEEMode = @ACSEEMode

if @@ERROR <>0
begin
  set @retcode = 1
end

if @existcount > 0

begin
select 'update'

insert into subtestlimitsLog
(
	Station_Name,
	subtest_name,
	SAP_Model_Name,
             Limit_Type,
             UL,
             LL,
             strLimit,
             flgLimit,
             Units,
             Description,
             Author,
             ACSEEMode,
             SPCParm,
             Hard_UL,
             Hard_LL,
             Limit_Date,
             ProductGroup_mask,
             Retire_Date,
             Limit_ID,
             Note_ID
)
select
	Station_Name,
	subtest_name,
	SAP_Model_Name,
             Limit_Type,
             UL,
             LL,
             strLimit,
             flgLimit,
             Units,
             Description,
             Author,
             ACSEEMode,
             SPCParm,
             Hard_UL,
             Hard_LL,
             Limit_Date,
             ProductGroup_mask,
             getdate(),
             Limit_ID,
             Note_ID
from subtestlimits where
Station_Name = @Station_name and
Subtest_name = @Subtest_Name and
SAP_Model_Name = @SAP_Model_Name and
ACSEEMode = @ACSEEMode


if @@ERROR <>0
begin
  set @retcode = 2
end


insert into SPCMapsLog
(
Limit_ID,
specgroup_id
)
select SPCMaps.Limit_ID, specgroup_ID
from SPCMaps
inner join subtestlimits on SPCMaps.Limit_ID = subtestlimits.Limit_ID
where 
Station_Name = @Station_name and
Subtest_name = @Subtest_Name and
SAP_Model_Name = @SAP_Model_Name and
ACSEEMode = @ACSEEMode


delete from SPCMaps
where SPCMaps.Limit_ID in
(
select Limit_ID from subtestlimits 
where 
Station_Name = @Station_name and
Subtest_name = @Subtest_Name and
SAP_Model_Name = @SAP_Model_Name and
ACSEEMode = @ACSEEMode
)

delete from subtestlimits where
Station_Name = @Station_name and
Subtest_name = @Subtest_Name and
SAP_Model_Name = @SAP_Model_Name and
ACSEEMode = @ACSEEMode




if @@ERROR <>0
begin
  set @retcode = 3
end

end


insert into subtestlimits
(
Station_Name,
SubTest_Name,
SAP_Model_Name,
Limit_Type,
UL,
LL,
strLimit,
flgLimit,
Units,
Description,
Author,
ACSEEMode,
SPCParm,
Hard_UL,
Hard_LL,
Limit_Date,
ProductGroup_Mask
)
values
(
	@Station_Name,
	@subtest_name,
	@SAP_Model_Name,
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
             @ProductGroup_mask
)

if @@ERROR <>0
begin
  set @retcode = 4
end
GO