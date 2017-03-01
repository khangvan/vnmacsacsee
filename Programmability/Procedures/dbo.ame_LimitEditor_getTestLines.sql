SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ame_LimitEditor_getTestLines] AS
set nocount on

/*
select RFU_Fru_ID, RFU_cFruCode, RFU_FruDescription
from SAP_RepairFrus
order by RFU_Order


select RAN_RepairAction_ID, RAN_ActCode, RAN_Critical, RAN_Description
from RepairAction




select OCD_ID, OCD_cCode, OCD_Desc
from OriginCodes
*/

select distinct TST_TestName
from tests
where TST_fPerformTest = 1
order by TST_TestName

/*
select distinct Station_Name
from Stations
where Perform_test='Y'
order by Station_Name

select MLN_MfgLine_ID, MLN_MfgLine
from MfgLine
order by MLN_MfgLine
*/
GO