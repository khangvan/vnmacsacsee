SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_EUG_GetLimits]
@sapmodel  char(20),
@station char(20),
@Vendor char(20),
@Plant char(10)
 AS
set nocount on
declare @workingstation char(20)


set @workingstation=@station
--print substring(@station,len(@station),1)
if  not exists(select
Station_Name, SubTest_Name, 
SAP_Model_Name, Limit_Type, UL,
 LL, strLimit, flgLimit,
 Units, Description, Author,
 ACSEEMode, SPCParm, Hard_UL,
 Hard_LL, Limit_Date, ProductGroup_Mask, 
Limit_ID, Note_ID, OpportunitiesforFail
from subtestlimits where SAP_Model_Name=@sapmodel and station_name = @station
)  and ( isnumeric(substring(@station,len(@station),1)) >0 )
begin
   set @workingstation = substring(@station,1,len(@station) -1 )
end

--print @workingstation
if not exists ( select station_name from ffc_eug_subtestlimits where SAP_Model_Name=@sapmodel and station_name=@workingstation and FFC_SO_VENDOR=@Vendor)
begin
insert into  FFC_EUG_Subtestlimits
(
Station_Name, SubTest_Name, 
SAP_Model_Name, Limit_Type, UL,
 LL, strLimit, flgLimit,
 Units, Description, Author,
 ACSEEMode, SPCParm, Hard_UL,
 Hard_LL, Limit_Date, ProductGroup_Mask, 
Limit_ID, Note_ID, OpportunitiesforFail,
FFC_SO_Vendor, FFC_SO_Plant
)
select
Station_Name, SubTest_Name, 
SAP_Model_Name, Limit_Type, UL,
 LL, strLimit, flgLimit,
 Units, Description, Author,
 ACSEEMode, SPCParm, Hard_UL,
 Hard_LL, Limit_Date, ProductGroup_Mask, 
Limit_ID, Note_ID, OpportunitiesforFail,@Vendor, @Plant
from subtestlimits where SAP_Model_Name=@sapmodel and station_name = @workingstation
end

select
count(*) as numberlimits
from subtestlimits where SAP_Model_Name=@sapmodel and station_name = @workingstation
GO