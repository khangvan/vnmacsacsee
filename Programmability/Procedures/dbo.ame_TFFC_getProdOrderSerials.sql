SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_getProdOrderSerials]
@ProdOrder char(20)
 AS

set nocount on



if  
(
select count(TFFC_Material) from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder
) > 0
begin
print 'found some'
select 'OK'
select TFFC_ID, TFFC_ProdOrder, TFFC_SerialNumber, TFFC_RefreshDate, TFFC_Reserved, TFFC_Reservedby, TFFC_Consumed, TFFC_ConsumedDate, TFFC_Material, 
TFFC_Description, TFFC_ACSSErial, TFFC_StationConsumedAt, TFFC_Period, TFFC_ReservedTime, isnull(BoxNumberChar,'') as BoxNumberChar, isnull(BoxNumberInt,0) as BoxNumberInt,
isnull(TFFC_IsTransferOrder,0) as TFFC_IsTransferOrder
from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder
end
else
begin
print 'none found'
select 'NONE'
end
GO