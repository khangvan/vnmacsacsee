SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getFruConstants] AS
set nocount on

select RFU_Fru_ID, RFU_cFruCode, RFU_FruDescription
from SAP_NewRepairFrus
order by RFU_Order


select RAN_RepairAction_ID, RAN_ActCode, RAN_Critical, RAN_Description
from RepairAction




select OCD_ID, OCD_cCode, OCD_Desc
from OriginCodes
GO