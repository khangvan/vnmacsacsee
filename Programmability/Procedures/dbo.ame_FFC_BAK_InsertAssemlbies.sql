SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_BAK_InsertAssemlbies]
@ACS_Serial char(20), 
@SAP_Model_No int, 
@Start_Station int, 
@Top_Model_Prfx char(5), 
@Start_Mfg datetime, 
@PSC_Serial char(20), 
@End_Mfg datetime, 
@Sales_Order char(10), 
@Line_Item char(6), 
@Current_State char(1), 
@assem_ID int
 AS

insert into FFC_BAK_Assemblies
(
ACS_Serial, 
SAP_Model_No, 
Start_Station, 
Top_Model_Prfx, 
Start_Mfg, 
PSC_Serial, 
End_Mfg, 
Sales_Order, 
Line_Item, 
Current_State, 
assem_ID
)
values
(
@ACS_Serial, 
@SAP_Model_No, 
@Start_Station, 
@Top_Model_Prfx, 
@Start_Mfg, 
@PSC_Serial, 
@End_Mfg, 
@Sales_Order, 
@Line_Item, 
@Current_State, 
@assem_ID
)
GO