SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_ConsumeSerial]
@ProdOrder nchar(20),
@acsserial char(20),
@material char(20),
@station char(20),
@serial char(20) OUTPUT
 AS

set nocount on


declare @tffcID int
begin transaction
select @tffcID =  min(TFFC_ID) from TFFC_SerialNumbers WITH (TABLOCKX)  where TFFC_ProdOrder = @ProdOrder and TFFC_Consumed = 0

if @tffcID is not null
begin

    select @serial = TFFC_SerialNumber from TFFC_SerialNumbers where TFFC_ID = @tffcID
    update TFFC_SerialNumbers set TFFC_Consumed =1, TFFC_ConsumedDate = getdate(), TFFC_ACSSerial=@acsserial,  TFFC_StationConsumedAt = @station
         where TFFC_ID = @tffcID

    select @serial
end
else
begin
set @serial ='BAD'
select @serial
end
commit transaction
GO