SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_Stage_DoCopy]
@username char(50),
@type int,
@note char(2000)
AS
set nocount on

declare @minstageid int
declare @deststationid int

declare @deststation char(20)
declare @destmodel char(20)
declare @sourcemodel char(20)
declare @lastsourcemodel char(20)
declare @minsourcemodelid int
declare @maxsourcemodelid int
declare @specificmaxsourcemodelid int
declare @sid int
declare @mynote char(2100)
declare cur_Models CURSOR FOR
select distinct Sap_Model_Name from stage_subtestlimits where len(rtrim(isnull(Sap_Model_Name,''))) > 0 and  tableuser=@username

select @minstageid = min(Stage_ID) from stage_subtestlimits where tableuser=@username

set @deststationid = @minstageid + 1

select @deststation = station_name from stage_subtestlimits where Stage_ID = @deststationid

select @maxsourcemodelid = max(Stage_ID) from stage_subtestlimits where tableuser=@username


select @deststationid
select @deststation



if @type = 0 
begin
--select 'about to delete all models'
set @mynote = '[' + rtrim(@username)+'][deleting all all models for station-move]' + @note
insert into ModelLimitHistory
(
MLH_Note,
MLH_StartDate,
MLH_EndDate
)
values
(
@mynote,
getdate(),
getdate()
)

set @sid = scope_identity()
               if @sid is null
               begin
                    set @sid = 0
                end

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
             @sid
from subtestlimits where
Station_Name = @deststation
  delete from subtestlimits where station_name = @deststation
end
   open cur_Models
   Fetch NEXT from cur_Models into @destmodel
   WHILE @@FETCH_STATUS = 0 
   begin
      if @type != 0 
      begin
--select 'about to delete individual station'
set @mynote = '[' + rtrim(@username)+'][deleting individual station model for station-move]' + @note
insert into ModelLimitHistory
(
MLH_Note,
MLH_StartDate,
MLH_EndDate
)
values
(
@mynote,
getdate(),
getdate()
)

set @sid = scope_identity()
               if @sid is null
               begin
                    set @sid = 0
                end
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
             @sid
from subtestlimits where
Station_Name = @deststation and SAP_Model_Name = @destmodel
        delete from subtestlimits where station_name = @deststation and SAP_Model_Name = @destmodel
      end

set @mynote = '[' + rtrim(@username)+'][station-model move]' + @note
insert into ModelLimitHistory
(
MLH_Note,
MLH_StartDate,
MLH_EndDate
)
values
(
@mynote,
getdate(),
getdate()
)

set @sid = scope_identity()
               if @sid is null
               begin
                    set @sid = 0
                end
      select @minsourcemodelid = min(Stage_ID) from stage_subtestlimits where tableuser = @username and SAP_Model_Name = @destmodel
      select @lastsourcemodel = Sap_Model_Name from stage_subtestlimits where Stage_ID = @minsourcemodelid
      select @specificmaxsourcemodelid = max(Stage_ID) from stage_subtestlimits where tableuser = @username and SAP_Model_Name = @destmodel
      while @destmodel = @lastsourcemodel and @minsourcemodelid <= @specificmaxsourcemodelid and @lastsourcemodel is not null
      begin

            insert into subtestlimits
            (
                 Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, 
                 strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL, 
                 Limit_Date, ProductGroup_Mask,  OpportunitiesforFail, Note_ID
            )
            select  @deststation, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, 
                     strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL, 
                     Limit_Date, ProductGroup_Mask,   OpportunitiesforFail , @sid
                    from Stage_Subtestlimits where Stage_ID = @minsourcemodelid

            set @minsourcemodelid = @minsourcemodelid + 2
            select @lastsourcemodel = Sap_Model_Name from stage_subtestlimits where Stage_id = @minsourcemodelid and tableuser = @username
      end 
select 'Got another model'
      Fetch NEXT from cur_Models into @destmodel
select @destmodel
   end
   close cur_Models
   deallocate cur_Models
GO