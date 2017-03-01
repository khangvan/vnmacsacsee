SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_AddSerialNonACSSerialForAudit]
@acsserial char(20),
@serial char(20),
@material char(20),
@description char(50),
@ProdOrder nchar(20),
@Period char(20),
@insertdate datetime,
@station char(20),
@testid char(50),
@transferorder int = 0
 AS

set nocount on

declare @dtnow datetime

set @dtnow = getdate()


if ( select count(TFFC_ID) from TFFC_Serialnumbers  WITH (TABLOCKX) where TFFC_Prodorder = @ProdOrder and TFFC_SerialNumber=@serial ) < 1
begin
insert into TFFC_SerialNumbers
(
TFFC_ProdOrder, TFFC_SerialNumber, TFFC_RefreshDate, TFFC_Reserved, TFFC_Reservedby,TFFC_ACSSerial, TFFC_StationConsumedAt,TFFC_Consumed,TFFC_ConsumedDate,TFFC_ReservedTime,
TFFC_Material, TFFC_Description, TFFC_Period, TFFC_IsTransferOrder
)
values
(
@ProdOrder, @serial, @insertdate,1,@acsserial,@acsserial, @station,1,@dtnow,@dtnow,
@material,@description, @Period, @transferorder
)

end

if not exists ( select psc_serial from [ACSEEState].[dbo].loci where psc_serial = @serial )
begin
 exec [ACSEEState].[dbo].ame_create_loci
-- Define input parameters
	@acsserial, @material, 
	 0,  0,
	 0,  0,
	@station,
	@testid,
	@station,
              @ProdOrder


exec [ACSEEState].[dbo].ame_update_loci
-- Define input parameters
	@acsserial, 
	@material,  'N',
	 ' ',  ' ',
	@serial,' ',
	0,  0,
	 0,  0,
	@station,
	@testid,
	@station ,
              @ProdOrder 
end

select 'OK'
GO