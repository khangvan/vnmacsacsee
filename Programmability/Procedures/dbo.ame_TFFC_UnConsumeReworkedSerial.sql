SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_UnConsumeReworkedSerial]
@ProdOrder nchar(20),
@acsserial char(20),
@success char(10) OUTPUT
 AS

set nocount on


declare @tffcid int
begin transaction
if exists
(
select TFFC_ID from TFFC_SerialNumbersWITH (TABLOCKX)   where TFFC_ProdOrder = @ProdOrder and TFFC_AcsSerial = @acsserial 
)
begin
    select @tffcid = TFFC_ID from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder and TFFC_ACSSerial = @acsserial 
    update TFFC_SerialNumbers set TFFC_Consumed = 0,  TFFC_Reserved = 0,  TFFC_reservedby='' , TFFC_AcsSerial ='' where TFFC_AcsSerial=@acsserial and TFFC_ProdOrder = @ProdOrder
set @success='OK'
end
else
begin
set @success = 'NO'
end

commit transaction
GO