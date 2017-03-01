SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_UnConsumeSerial_TM]
@ProdOrder nchar(20),
@acsserial char(20),
@material char(20),
@serial char(20),
@success char(10) OUTPUT
 AS

set nocount on


declare @tffcid int
begin transaction
if exists
(
select TFFC_ID from TFFC_SerialNumbers WITH (TABLOCKX)  where TFFC_ProdOrder = rtrim(@ProdOrder) and TFFC_SerialNumber = rtrim(@serial) and TFFC_Consumed = 1
)
begin
    select @tffcid = TFFC_ID from TFFC_SerialNumbers where TFFC_ProdOrder = rtrim(@ProdOrder) and TFFC_SerialNumber = rtrim(@serial) 
--and TFFC_Consumed = 1
    update TFFC_SerialNumbers set TFFC_Consumed = 0 , TFFC_Reserved = 0 where TFFC_ID = @tffcid
set @success='OK'
end
else
begin
set @success = 'NO'
end
commit transaction
GO