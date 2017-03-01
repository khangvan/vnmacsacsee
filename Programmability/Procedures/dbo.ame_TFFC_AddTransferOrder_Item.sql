SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_TFFC_AddTransferOrder_Item]
@WHSE char(3),
@TONUM char(10),
@material char(20),
@description char(50),
@WERKS char(10),
@QTY int,
@Units char(10)
 AS
set nocount on



if not exists ( select TransferOrder_ID from TFFC_TransferOrders where TransferOrder_WHSE = @WHSE and TransferOrder_OrderNum = @TONUM and TransferOrder_material = @material)
begin
insert into TFFC_TransferOrders
(
TransferOrder_WHSE, 
TransferOrder_OrderNum, 
TransferOrder_Material, 
TransferOrder_Description, 
TransferOrder_WERKS, 
TransferOrder_Qty, 
TransferOrder_Units,
TransferOrder_CurrentCount
)
values
(
@WHSE,
@TONUM,
@material,
@description,
@WERKS,
@QTY,
@Units,
0
)
end
GO