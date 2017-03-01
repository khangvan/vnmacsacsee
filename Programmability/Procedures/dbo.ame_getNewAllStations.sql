SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getNewAllStations] AS
set nocount on

select
Station_Count,
Station_Name,
Description,
ACS_Serial_ID,
Gen_PSC_Serial,
Print_Asm_Label,
Print_Unit_Label,
Print_Carton_Label,
Print_Extra_Label,
Allow_Overrides,
Finish_Assembly,
Perform_Test,
Assign_Sales_Order,
Backflush,
Status,
Machine_Name,
FactoryGroup_Mask,
ProductGroup_Mask,
Order_Value,
Thin_Client,
Station_Type,
Waterfall_Server_Machine_Name,
Application_Server_Machine_Name,
Business_Server_Machine_Name,
STN_MfgLine_ID
from stations 
order by station_name
GO