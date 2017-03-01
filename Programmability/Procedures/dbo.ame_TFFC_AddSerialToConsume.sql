SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_AddSerialToConsume]
@serial char(20),
@material char(20),
@description char(50),
@ProdOrder nchar(20),
@Period char(20),
@insertdate datetime,
@PrintOnDemand char(2) = 'U'
 AS

set nocount on

begin transaction

if not exists ( select TFFC_ID from TFFC_Serialnumbers  WITH (TABLOCKX) where TFFC_Prodorder = @ProdOrder and TFFC_SerialNumber=@serial )
begin

insert into TFFC_SerialNumbers
(
TFFC_ProdOrder, TFFC_SerialNumber, TFFC_RefreshDate, TFFC_Reserved, TFFC_Reservedby,TFFC_Consumed,
TFFC_Material, TFFC_Description, TFFC_Period, TFFC_PrintOnDemand
)
values
(
@ProdOrder, @serial, @insertdate,0,'',0,
@material,@description, @Period, @PrintOnDemand
)
end

commit transaction
select 'OK'
GO