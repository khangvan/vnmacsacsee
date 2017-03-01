SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_EUG_GetBOMs]
 AS
select SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, Station, Part_Type, ACSEEMode, Display_Option, Display_Order, FileMap, Qty, Lvl
from FFC_EUG_Parts_Level
GO