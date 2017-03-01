SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_UnConsumeSerial]
@ProdOrder nchar(20),
@acsserial char(20),
@material char(20),
@serial char(20),
@success char(10) OUTPUT
 AS

set nocount on

declare @strLog char(300)

declare @tffcid int
begin transaction
if exists
(
select TFFC_ID from TFFC_SerialNumbers WITH (TABLOCKX)  where TFFC_ProdOrder = @ProdOrder and TFFC_SerialNumber = @serial and TFFC_Consumed = 1
)
begin
    select @tffcid = TFFC_ID from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder and TFFC_SerialNumber = @serial and TFFC_Consumed = 1
    update TFFC_SerialNumbers set TFFC_Consumed = 0, TFFC_Reserved=0 where TFFC_ID = @tffcid



set @strLog = 'UNconsume1 pid=' + convert(varchar,@@SPID) + ' prodorder=[' + isnull(@ProdOrder,'') +']  acsserial=[' + isnull(@acsserial,'') +']   tffcID=[' + convert(varchar,isnull(@tffcID,0)) +']'


--set @strLog = "consume1 pid=" + @@SPID + " prodorder=[" + @ProdOrder +"]  acsserial=[" + @acsserial +"] usedserial=["+ @usedserial +"]   tffcID=[" + @tffcID +"]"

insert into TFFC_ConsumeLog
(
LogTime,
LogRecord,
ACSSerial,
SAPSerial
)
values
(
getdate(),
@strLog,
@acsserial,
@serial
)

set @success='OK'
end
else
begin
set @success = 'NO'
end
commit transaction
GO