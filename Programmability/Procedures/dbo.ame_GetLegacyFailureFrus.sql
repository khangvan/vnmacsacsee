SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_GetLegacyFailureFrus] 
@serial char(20),
@rvalue int OUTPUT
AS
set nocount on

declare @type int
declare @SAP_Model varchar(80)


select @SAP_Model = 
FLG_Model
from LegacyFruFailureLog
WHERE FLG_ACSSN = @serial
order by FLG_FailureLogDate

/*

set @type =1
if @SAP_Model like '3-%'
set @type = 2 

*/



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
TST_fInPCB
from LegacyFruFailureLog
inner join SAP_NewRepairFrus on FLG_Fru_ID = RFU_Fru_ID
inner join RepairAction on FLG_RepairAction_ID = RAN_RepairAction_ID
inner  join OriginCodes on FLG_OriginCode_ID = OCD_ID
 inner join Tests on STN_Name = FLG_Station 
WHERE FLG_ACSSN = @serial
order by FLG_FailureLogDate


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


set @rvalue = 0
GO