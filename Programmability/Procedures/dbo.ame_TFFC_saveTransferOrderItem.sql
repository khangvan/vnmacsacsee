SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_TFFC_saveTransferOrderItem]
@acsserial char(20),
@serial char(20),
@material char(20),
@description char(50),
@TransferOrder char(20),
@insertdate char(20),
@station char(20),
@testid char(50),
@boxnumberstring char(20),
@boxnumber int
 AS
set nocount on

declare @tffcid int

select @tffcid = tffc_id from tffc_serialnumbers where tffc_serialnumber= @serial and isnull(TFFC_IsTransferOrder,0) =1
if @tffcid is not  null
begin
select 'DUPLICATE' as response
end
else
begin
select 'OK' as response
insert into tffc_serialnumbers
(
TFFC_ProdOrder, TFFC_SerialNumber, TFFC_RefreshDate, TFFC_Material, 
TFFC_Description, TFFC_ACSSErial, TFFC_StationConsumedAt, 
BoxNumberChar, BoxNumberInt, TFFC_WasAudited, TFFC_IsTransferOrder

)
values
(
@TransferOrder, @serial, getdate(),@material,
@description,@acsserial,@station,
@boxnumberstring, @boxnumber, 0,1
)
end
GO