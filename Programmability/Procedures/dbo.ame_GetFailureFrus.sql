SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_GetFailureFrus] 
@serial char(20),
@rvalue int OUTPUT
AS
set nocount on

declare @type int
declare @SAP_Model varchar(80)
declare @countfrus int

declare @maxflgflid int
declare @lookbackflgflid int

declare @RawFruFailure table (
FLG_FL_ID int not null,
FLG_RepairAction_ID int null,
FLG_OriginCode_ID int null,
FLG_Fru_ID int null,
FLG_ACSSN_ID int null,
FLG_TL_ID int null,
FLG_ACSSN char(80) null,
FLG_Failure char(80) null,
FLG_Station_ID int null,
FLG_Station char(80) null,
FLG_RootCauseComment varchar(80) null,
FLG_RootCauseOwner varchar(80) null,
FLG_Critical tinyint null,
FLG_ORT char(10) null,
FLG_Technician varchar(80) null,
FLG_PreventativeAction varchar(80) null,
FLG_Comments varchar(80) null,
FLG_FailureLogDate datetime null,
FLG_DateGrouping_ID int null,
FLG_Type int null,
FLG_Touched int null,
FLG_ReportType int null,
FLG_Generated tinyint null,
FLG_LastModified datetime null
)


select @maxflgflid = max(FLG_FL_ID) from RawFruFailureLog

set @lookbackflgflid = @maxflgflid - 200000

insert into @RawFruFailure
(
FLG_FL_ID ,
FLG_RepairAction_ID ,
FLG_OriginCode_ID ,
FLG_Fru_ID ,
FLG_ACSSN_ID ,
FLG_TL_ID ,
FLG_ACSSN ,
FLG_Failure ,
FLG_Station_ID ,
FLG_Station ,
FLG_RootCauseComment ,
FLG_RootCauseOwner ,
FLG_Critical ,
FLG_ORT,
FLG_Technician ,
FLG_PreventativeAction ,
FLG_Comments ,
FLG_FailureLogDate ,
FLG_DateGrouping_ID ,
FLG_Type ,
FLG_Touched ,
FLG_ReportType ,
FLG_Generated ,
FLG_LastModified
)
select
FLG_FL_ID ,
FLG_RepairAction_ID ,
FLG_OriginCode_ID ,
FLG_Fru_ID ,
FLG_ACSSN_ID ,
FLG_TL_ID ,
FLG_ACSSN ,
FLG_Failure ,
FLG_Station_ID ,
FLG_Station ,
FLG_RootCauseComment ,
FLG_RootCauseOwner ,
FLG_Critical ,
FLG_ORT,
FLG_Technician ,
FLG_PreventativeAction ,
FLG_Comments ,
FLG_FailureLogDate ,
FLG_DateGrouping_ID ,
FLG_Type ,
FLG_Touched ,
FLG_ReportType ,
FLG_Generated ,
FLG_LastModified
from RawFruFailureLog where FLG_FL_ID > @lookbackflgflid


select @SAP_Model = 
SAP_Model
from
( select FLG_TL_ID, FLG_FailureLogDate from @RawFruFailure ) v
inner join testlog on v.FLG_TL_ID = TL_ID
WHERE ACS_Serial = @serial
order by v.FLG_FailureLogDate

/*

set @type =1
if @SAP_Model like '3-%'
set @type = 2 

*/



select @countfrus =  count(*) from 
( select FLG_TL_ID, FLG_FailureLogDate from @RawFruFailure  ) v
inner join testlog on v.FLG_TL_ID = TL_ID where ACS_Serial = @serial

print 'about count'
print @countfrus

if @countfrus > 0
begin
/*
select FLG_FailureLogDate,
 FLG_ORT, 
SAP_Model,
FLG_ACSSN,
FLG_Station,
FLG_Failure,
FLG_Critical, 
RFU_cFruCode, 
RFU_FruDescription,
RAN_ActCode, 
RAN_Description,
FLG_Comments,
OCD_cCode, 
OCD_Desc,
FLG_RootCauseComment, 
FLG_RootCauseOwner, 
FLG_PreventativeAction,
FLG_FL_ID, 
FLG_Touched,
FLG_Technician,
TST_fInPCB
from RawFruFailureLog
inner join testlog on RawFruFailureLog.FLG_TL_ID = TL_ID
inner join SAP_NewRepairFrus on FLG_Fru_ID = RFU_Fru_ID
inner join RepairAction on FLG_RepairAction_ID = RAN_RepairAction_ID
inner  join OriginCodes on FLG_OriginCode_ID = OCD_ID
 inner join Tests on STN_Name = FLG_Station 
WHERE ACS_Serial = @serial
order by FLG_FailureLogDate
*/


select FLG_FailureLogDate,
 FLG_ORT, 
SAP_Model,
FLG_ACSSN,
FLG_Station,
FLG_Failure,
FLG_Critical, 
RFU_cFruCode, 
RFU_FruDescription,
RAN_ActCode, 
RAN_Description,
FLG_Comments,
OCD_cCode, 
OCD_Desc,
FLG_RootCauseComment, 
FLG_RootCauseOwner, 
FLG_PreventativeAction,
FLG_FL_ID, 
FLG_Touched,
FLG_Technician,
TST_fInPCB,
'A'
from
(
 select 
FLG_FailureLogDate,
 FLG_ORT, 
FLG_ACSSN,
FLG_Station,
FLG_Failure,
FLG_Critical, 
FLG_Comments,
FLG_RootCauseComment, 
FLG_RootCauseOwner, 
FLG_PreventativeAction,
FLG_FL_ID, 
FLG_Touched,
FLG_Technician,
FLG_Fru_ID,
FLG_OriginCode_ID,
FLG_RepairAction_ID,
FLG_TL_ID
from @RawFruFailure
) v
inner join testlog on v.FLG_TL_ID = TL_ID
inner join SAP_NewRepairFrus on v.FLG_Fru_ID = RFU_Fru_ID
inner join RepairAction on v.FLG_RepairAction_ID = RAN_RepairAction_ID
inner  join OriginCodes on v.FLG_OriginCode_ID = OCD_ID
 inner join Tests on STN_Name = FLG_Station 
WHERE ACS_Serial = @serial
/*
select FLG_FailureLogDate,
 FLG_ORT, 
SAP_Model,
FLG_ACSSN,
FLG_Station,
FLG_Failure,
FLG_Critical, 
RFU_cFruCode, 
RFU_FruDescription,
RAN_ActCode, 
RAN_Description,
FLG_Comments,
OCD_cCode, 
OCD_Desc,
FLG_RootCauseComment, 
FLG_RootCauseOwner, 
FLG_PreventativeAction,
FLG_FL_ID, 
FLG_Touched,
FLG_Technician,
TST_fInPCB,
'A'
from RawFruFailureLog
inner join testlog on RawFruFailureLog.FLG_TL_ID = TL_ID
inner join SAP_NewRepairFrus on FLG_Fru_ID = RFU_Fru_ID
inner join RepairAction on FLG_RepairAction_ID = RAN_RepairAction_ID
inner  join OriginCodes on FLG_OriginCode_ID = OCD_ID
 inner join Tests on STN_Name = FLG_Station 
WHERE ACS_Serial = @serial
and FLG_FL_ID > 100000
*/
union
select FLG_FailureLogDate,
 FLG_ORT, 
FLG_Model,
FLG_ACSSN,
FLG_Station,
FLG_Failure,
FLG_Critical, 
RFU_cFruCode, 
RFU_FruDescription,
RAN_ActCode, 
RAN_Description,
FLG_Comments,
OCD_cCode, 
OCD_Desc,
FLG_RootCauseComment, 
FLG_RootCauseOwner, 
FLG_PreventativeAction,
FLG_FL_ID, 
FLG_Touched,
FLG_Technician,
TST_fInPCB,
'L'
from LegacyFruFailureLog
inner join SAP_NewRepairFrus on FLG_Fru_ID = RFU_Fru_ID
inner join RepairAction on FLG_RepairAction_ID = RAN_RepairAction_ID
inner  join OriginCodes on FLG_OriginCode_ID = OCD_ID
 inner join Tests on STN_Name = FLG_Station 
WHERE FLG_ACSSN = @serial
order by FLG_FailureLogDate


end

else
begin
select FLG_FailureLogDate,
 FLG_ORT, 
FLG_Model,
FLG_ACSSN,
FLG_Station,
FLG_Failure,
FLG_Critical, 
RFU_cFruCode, 
RFU_FruDescription,
RAN_ActCode, 
RAN_Description,
FLG_Comments,
OCD_cCode, 
OCD_Desc,
FLG_RootCauseComment, 
FLG_RootCauseOwner, 
FLG_PreventativeAction,
FLG_FL_ID, 
FLG_Touched,
FLG_Technician,
TST_fInPCB,
'L'
from LegacyFruFailureLog
inner join SAP_NewRepairFrus on FLG_Fru_ID = RFU_Fru_ID
inner join RepairAction on FLG_RepairAction_ID = RAN_RepairAction_ID
inner  join OriginCodes on FLG_OriginCode_ID = OCD_ID
 inner join Tests on STN_Name = FLG_Station 
WHERE FLG_ACSSN = @serial
order by FLG_FailureLogDate
end


select RFU_cFruCode, RFU_FruDescription
from SAP_NewRepairFrus
order by RFU_Order


select RAN_ActCode, RAN_Critical, RAN_Description
from RepairAction




select CAC_Code, CAC_Description
from CauseCategory



select OCD_cCode, OCD_Desc
from OriginCodes


/*
select RFU_cFruCode, RFU_FruDescription,
isnull(Fru_Category,'zznone') as testname,
RFU_Type,
isnull(Fru_Frequency,0)
from Fru_Frequency
right  outer join SAP_NewRepairFrus on Fru_Fru_ID = RFU_Fru_ID
order by Fru_Frequency desc, RFU_cFruCode
*/


select FALT_cFruCode, FALT_Description, FALT_Testname, FALT_Type, FALT_Frequency
from Fru_AllFreqTest
order by FALT_Frequency desc, FALT_Testname, FALT_cFruCode

select RAN_ActCode, RAN_Critical, RAN_Description, RAN_Type
from RepairAction


select OCD_cCode, OCD_Desc, OCD_Type
from OriginCodes



select distinct Station_Name, Description, Station_Count, TST_fInPCB
from Stations
inner join tests on Station_Name = STN_Name
order by Station_Name



set @rvalue = 0
GO