SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_LimitEditor_Delete_limit]
-- Define input parameters
	@Station_Name 	char(20) = NULL,
	@Subtest_Name char(20)=NULL,
	@SAP_Model_Name char(20)=NULL,
             @ACSEEMode int,
             @author char(25),
              @note char(1000) = '',
              @retcode int OUTPUT

AS
set nocount on

declare @existcount int

declare @sid int
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

--set @note = 'Deleted by-' + @author

insert into ModelLimitHistory
(
MLH_Note,
MLH_StartDate,
MLH_EndDate
)
values
(
@note,
getdate(),
getdate()
)

set @sid = scope_identity()
               if @sid is null
               begin
                    set @sid = 0
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
             @sid
from subtestlimits where
Station_Name = @Station_name and
Subtest_name = @Subtest_Name and
SAP_Model_Name = @SAP_Model_Name and
ACSEEMode = @ACSEEMode
if @@ERROR <>0
begin
  set @retcode = 2
end


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
GO