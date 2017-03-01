SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_TFFC_getTransferOrder]
@TransferOrder char(20)
 AS
set nocount on
declare @tffcInfoID int
declare @tffcid int

select @tffcInfoID = TransferOrder_ID from TFFC_TransferOrders where TransferOrder_OrderNum = @TransferOrder

if @tffcInfoID is not null
   begin

     select 'OK' as InfoFound
    select TransferOrder_ID, TransferOrder_WHSE, TransferOrder_OrderNum, TransferOrder_material, TransferOrder_description, TransferOrder_WERKS, 
          TransferOrder_Qty, TransferOrder_Units, TransferOrder_CurrentCount
     from TFFC_TransferOrders where TransferOrder_orderNum = @TransferOrder


     select @tffcid = tffc_id from tffc_serialnumbers where tffc_prodorder = @TransferOrder 

     if @tffcid is not null
          begin
              select 'OK' as Response
              select TFFC_ProdOrder, TFFC_SerialNumber, TFFC_Material, isnull(BoxNumberChar, '') as BoxNumberChar, isnull(BoxNumberInt,0) as BoxNumberInt,
                 isnull(TFFC_IsTransferOrder,0) as TFFC_IsTransferOrder from TFFC_Serialnumbers where  tffc_prodorder = @TransferOrder 
         end
    else
       begin
           select 'NOTFOUND' as Response
      end
   end
    else
begin
select 'NOTFOUND' as InfoFound
end
GO