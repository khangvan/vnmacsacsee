SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getAuditCodes] 
AS
set nocount on
select RFU_Fru_ID, RFU_FruDescription, RFU_cFruCode, RFU_FruCode,
RFU_Order, RFU_Type, RFU_Station, RFU_Remark, RFU_ProductLine
 from sap_newRepairFrus where RFU_Type = 3
GO