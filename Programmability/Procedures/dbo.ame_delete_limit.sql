SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_delete_limit]
-- Define input parameters
	@Station_Name 	char(20) = NULL,
	@Subtest_Name char(20)=NULL,
	@SAP_Model_Name char(20)=NULL,
             @ACSEEMode int

AS
set nocount on

declare @existcount int

select @existcount = count(*) from subtestlimits where 
station_Name = @Station_name and
Subtest_Name = @Subtest_Name and
SAP_Model_Name = @SAP_Model_Name and
ACSEEMode = @ACSEEMode



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
             Retire_date
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
             getdate()
from subtestlimits where
Station_Name = @Station_name and
Subtest_name = @Subtest_Name and
SAP_Model_Name = @SAP_Model_Name and
ACSEEMode = @ACSEEMode


delete from subtestlimits where
Station_Name = @Station_name and
Subtest_name = @Subtest_Name and
SAP_Model_Name = @SAP_Model_Name and
ACSEEMode = @ACSEEMode
end
GO