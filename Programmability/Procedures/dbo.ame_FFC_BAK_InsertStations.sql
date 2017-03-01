SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_BAK_InsertStations] 

@Station_Count int, 
@Station_Name char(20), 
@Description nchar(40), 
@ACS_Serial_ID char(2), 
@Gen_PSC_Serial char(1), 
@Print_Asm_Label char(1), 
@Print_Unit_Label char(1), 
@Print_Carton_Label char(1), 
@Print_Extra_label char(1), 
@Allow_Overrides char(1), 
@Finish_Assembly char(1), 
@Perform_Test char(1), 
@Assign_Sales_Order char(1), 
@Backflush char(1), 
@Status char(1), 
@Machine_Name char(30), 
@FactoryGroup_Mask int, 
@ProductGroup_Mask int, 
@Order_Value int, 
@Thin_Client char(1), 
@Station_Type char(3), 
@Waterfall_Server_Machine_Name char(20), 
@Application_Server_Machine_Name char(20), 
@Business_Server_Machine_Name char(20), 
@STN_MfgLine_ID int, 
@SPCEnabled char(1)
 AS
set nocount on


insert into FFC_BAK_Stations
(
Station_Count, 
Station_Name, 
Description, 
ACS_Serial_ID, 
Gen_PSC_Serial, 
Print_Asm_Label, 
Print_Unit_Label, 
Print_Carton_Label, 
Print_Extra_label, 
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
STN_MfgLine_ID, 
SPCEnabled
)
values
(
@Station_Count, 
@Station_Name, 
@Description, 
@ACS_Serial_ID, 
@Gen_PSC_Serial, 
@Print_Asm_Label, 
@Print_Unit_Label, 
@Print_Carton_Label, 
@Print_Extra_label, 
@Allow_Overrides, 
@Finish_Assembly, 
@Perform_Test, 
@Assign_Sales_Order, 
@Backflush, 
@Status, 
@Machine_Name, 
@FactoryGroup_Mask, 
@ProductGroup_Mask, 
@Order_Value, 
@Thin_Client, 
@Station_Type, 
@Waterfall_Server_Machine_Name, 
@Application_Server_Machine_Name, 
@Business_Server_Machine_Name, 
@STN_MfgLine_ID, 
@SPCEnabled
)
GO