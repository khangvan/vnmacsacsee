SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getLegacyConstants] AS
set nocount on

select station_name, station_count,TST_fInPCB from stations
inner join Tests on Station_Name = STN_Name
where Perform_Test='Y' 
order by station_name




select RFU_cFruCode, RFU_FruDescription,
isnull(Fru_Category,'zznone') as testname,
RFU_Type,
isnull(Fru_Frequency,0), RFU_Fru_ID
from Fru_Frequency
right  outer join SAP_NewRepairFrus on Fru_Fru_ID = RFU_Fru_ID
order by Fru_Frequency desc, RFU_cFruCode



select RAN_ActCode, RAN_Critical, RAN_Description, RAN_Type, RAN_RepairAction_ID
from RepairAction


select OCD_cCode, OCD_Desc, OCD_Type, OCD_ID
from OriginCodes
GO