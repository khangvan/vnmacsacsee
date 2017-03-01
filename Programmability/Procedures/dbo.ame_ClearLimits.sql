SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_ClearLimits]
-- Define input parameters
	@Station_Name 	char(20) = NULL,
	@SAP_Model_Name char(20)=NULL,
              @note char(1000) = '',
              @retcode int OUTPUT
AS
set nocount on


declare @existcount int

declare @sid int

set @retcode = 0




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
 

select @existcount = count(*) from subtestlimits where 
station_Name = @Station_name and
SAP_Model_Name = @SAP_Model_Name





if @existcount > 0
begin
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
SAP_Model_Name = @SAP_Model_Name


delete from subtestlimits where
Station_Name = @Station_name and
SAP_Model_Name = @SAP_Model_Name

end
else
begin
set @retcode = -1
end
GO