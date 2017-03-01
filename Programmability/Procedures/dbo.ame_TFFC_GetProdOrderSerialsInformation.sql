SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_GetProdOrderSerialsInformation]
@ProdOrder char(20)
 AS

set nocount on



if exists 
(
select TFFC_Material from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder
)
begin
print 'found some'
select 'OK'
select TFFC_ID, TFFC_ProdOrder, TFFC_SerialNumber, TFFC_RefreshDate, TFFC_Reserved, TFFC_Reservedby, TFFC_Consumed, TFFC_ConsumedDate, TFFC_Material, TFFC_Description, TFFC_ACSSErial, TFFC_StationConsumedAt, TFFC_Period, TFFC_ReservedTime
from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder
end
else
begin
print 'none found'
select 'NONE'
end
GO