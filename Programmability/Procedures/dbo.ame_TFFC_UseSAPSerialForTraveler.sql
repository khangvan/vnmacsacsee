SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_UseSAPSerialForTraveler]
@ProdOrder char(20),
@material char(20),
@station char(20),
@serial char(20) OUTPUT
 AS

set nocount on

declare @strLog1 char(300)
declare @strLog2 char(300)
declare @strLog3 char(300)

declare @tffcID int
begin transaction
select @tffcID =  min(TFFC_ID) from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder and TFFC_Consumed = 0 and TFFC_Reserved = 0


--set @strLog1 = 'reserve1 pid=' + convert(varchar, @@SPID) + ' prodorder=[' + isnull(@ProdOrder,'') +']  acsserial=[' + isnull(@acsserial,'') +']   tffcID=[' + convert(varchar,isnull(@tffcID,0)) +']'


--set @strLog = "consume1 pid=" + @@SPID + " prodorder=[" + @ProdOrder +"]  acsserial=[" + @acsserial +"] usedserial=["+ @usedserial +"]   tffcID=[" + @tffcID +"]"
/*
insert into TFFC_ReserveLog
(
LogTime,
LogRecord,
ACSSerial
)
values
(
getdate(),
@strLog1,
@acsserial
)
*/
if @tffcID is not null
begin

    select @serial = TFFC_SerialNumber from TFFC_SerialNumbers where TFFC_ID = @tffcID
    update TFFC_SerialNumbers set TFFC_Reserved =1, TFFC_Reservedby=TFFC_SerialNumber, TFFC_ReservedTime = getdate(), TFFC_Consumed=1,TFFC_ConsumedDate=getdate()
         where TFFC_ID = @tffcID

end
else
begin
set @serial ='BAD'
end
select @serial as serial
commit

GO