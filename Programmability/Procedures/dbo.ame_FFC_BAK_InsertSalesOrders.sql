SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_BAK_InsertSalesOrders] 
@FFC_BAK_Id int, 
@FFC_BAK_SalesOrder nchar(20), 
@FFC_BAK_Model nchar(20), 
@FFC_BAK_Name nchar(50), 
@FFC_BAK_Street nchar(50), 
@FFC_BAK_City nchar(50), 
@FFC_BAK_State nchar(10), 
@FFC_BAK_PostalCode nchar(10), 
@FFC_BAK_IntCode nchar(3), 
@FFC_BAK_OTDDate datetime, 
@FFC_BAK_Qty int, 
@FFC_BAK_QtyBoxed int, 
@FFC_BAK_Vender nchar(10), 
@FFC_BAK_Country nchar(10), 
@FFC_BAK_Hiearchy nchar(20), 
@FFC_BAK_Blockingcode nchar(3), 
@FFC_BAK_CustPart nchar(22), 
@FFC_BAK_Attn nchar(35) , 
@FFC_BAK_PO nchar(21)
AS

set nocount on
insert into FFC_BAK_SalesOrders
(
FFC_BAK_Id, 
FFC_BAK_SalesOrder, 
FFC_BAK_Model, 
FFC_BAK_Name, 
FFC_BAK_Street, 
FFC_BAK_City, 
FFC_BAK_State, 
FFC_BAK_PostalCode, 
FFC_BAK_IntCode, 
FFC_BAK_OTDDate, 
FFC_BAK_Qty, 
FFC_BAK_QtyBoxed, 
FFC_BAK_Vender, 
FFC_BAK_Country, 
FFC_BAK_Hiearchy, 
FFC_BAK_Blockingcode, 
FFC_BAK_CustPart, 
FFC_BAK_Attn, 
FFC_BAK_PO
)
values
(
@FFC_BAK_Id, 
@FFC_BAK_SalesOrder, 
@FFC_BAK_Model, 
@FFC_BAK_Name, 
@FFC_BAK_Street, 
@FFC_BAK_City, 
@FFC_BAK_State, 
@FFC_BAK_PostalCode, 
@FFC_BAK_IntCode, 
@FFC_BAK_OTDDate, 
@FFC_BAK_Qty, 
@FFC_BAK_QtyBoxed, 
@FFC_BAK_Vender, 
@FFC_BAK_Country, 
@FFC_BAK_Hiearchy, 
@FFC_BAK_Blockingcode, 
@FFC_BAK_CustPart, 
@FFC_BAK_Attn, 
@FFC_BAK_PO
)
GO