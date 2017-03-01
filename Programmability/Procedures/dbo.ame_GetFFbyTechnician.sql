SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_GetFFbyTechnician] 
@strTechnician char(80),
@rvalue int OUTPUT
AS

declare @type int
declare @SAP_Model varchar(80)

/*
select @SAP_Model = 
SAP_Model
from RawFruFailureLog
inner join testlog on RawFruFailureLog.FLG_TL_ID = TL_ID
WHERE ACS_Serial = @serial
order by FLG_FailureLogDate



set @type =1
if @SAP_Model like '3-%'
set @type = 2 
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
FLG_Technician
from RawFruFailureLog
inner join testlog on RawFruFailureLog.FLG_TL_ID = TL_ID
inner join SAP_RepairFrus on FLG_Fru_ID = RFU_Fru_ID
inner join RepairAction on FLG_RepairAction_ID = RAN_RepairAction_ID
inner  join OriginCodes on FLG_OriginCode_ID = OCD_ID
WHERE FLG_Technician = @strTechnician
order by FLG_FailureLogDate


select RFU_cFruCode, RFU_FruDescription
from SAP_NewRepairFrus
--where RFU_Type = @type
order by RFU_Order


select RAN_ActCode, RAN_Critical, RAN_Description
from RepairAction
--WHERE RAN_Type = @type



select CAC_Code, CAC_Description
from CauseCategory
--WHERE CAC_Type = @type


select OCD_cCode, OCD_Desc
from OriginCodes
--where OCD_Type = @type

set @rvalue = 0
GO