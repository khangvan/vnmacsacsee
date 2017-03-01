SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_LimitEditor_AddUpdate_limit]
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


/*

if exists(select * from subtestlimits where station_name=@StationName
   and sap_model_name=@DestinationSAPModel)
	begin
		select 'Error - Destination Model already exists'
		return
	end

if not exists(select * from subtestlimits where station_name=@StationName
   and sap_model_name=@SourceSAPModel)
	begin
		select 'Error - Source Model does not exist'
		return
	end

CREATE TABLE #zzzz (
	[Station_Name] [char] (20) NOT NULL ,
	[SubTest_Name] [char] (20) NOT NULL ,
	[SAP_Model_Name] [char] (20) NOT NULL ,
	[Limit_Type] [char] (1) NOT NULL ,
	[UL] [float] NULL ,
	[LL] [float] NULL ,
	[strLimit] [char] (40) NULL ,
	[flgLimit] [char] (1) NULL ,
	[Units] [char] (10) NOT NULL ,
	[Description] [char] (50) NOT NULL ,
	[Author] [char] (25) NOT NULL ,
	[ACSEEMode] [int] NOT NULL ,
	[SPCParm] [char] (1) NOT NULL ,
	[Hard_UL] [float] NULL ,
	[Hard_LL] [float] NULL ,
	[Limit_Date] [datetime] NOT NULL ,
	[ProductGroup_Mask] [int] NULL ,
) ON [PRIMARY]


insert into #zzzz
select * from subtestlimits
where station_name=@StationName
and sap_model_name=@SourceSAPModel

--select * from #zzzz
update #zzzz
set sap_model_name=@DestinationSAPModel

insert into subtestlimits
select * from #zzzz

drop table #zzzz


*/
select 'OK'

--and sap_model_name='4420-11121'
--and sap_model_name='4420-11121-01000'
GO