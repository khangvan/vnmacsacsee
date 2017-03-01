SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_UnReserveSerial]
@ProdOrder nchar(20),
@acsserial char(20),
@material char(20),
@serial char(20),
@success char(10) OUTPUT
 AS

set nocount on

declare @strLog1 char(512)
declare @tffcid int

declare @pscsn char(20)


set @strLog1 = 'unreserve1 pid=' + convert(varchar, @@SPID) + ' prodorder=[' + isnull(@ProdOrder,'') +']  acsserial=[' + isnull(@acsserial,'') +']   '


--set @strLog = "consume1 pid=" + @@SPID + " prodorder=[" + @ProdOrder +"]  acsserial=[" + @acsserial +"] usedserial=["+ @usedserial +"]   tffcID=[" + @tffcID +"]"

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
begin transaction
if exists
(
select TFFC_ID from TFFC_SerialNumbers WITH (TABLOCKX)  where TFFC_ProdOrder = rtrim(@ProdOrder) and TFFC_SerialNumber = rtrim(@serial) and TFFC_Reserved = 1 and TFFC_Reservedby = rtrim(@acsserial)
)
begin
    select @tffcid = TFFC_ID from TFFC_SerialNumbers where TFFC_ProdOrder =rtrim( @ProdOrder) and TFFC_SerialNumber = rtrim(@serial) and TFFC_Reserved = 1  and TFFC_Reservedby = rtrim(@acsserial)
    update TFFC_SerialNumbers set TFFC_Reserved = 0,  TFFC_Consumed=0,TFFC_Reservedby='' where TFFC_ID = @tffcid

    select @pscsn = psc_serial from [ACSEEState].[dbo].loci where acs_serial = @acsserial
    if @pscsn is not null
    begin
       update [ACSEESTate].[dbo].loci set psc_serial='' where acs_serial = @acsserial
    end
set @strLog1 = 'unreserve2 pid=' + convert(varchar, @@SPID) + ' prodorder=[' + isnull(@ProdOrder,'') +']  acsserial=[' + isnull(@acsserial,'') +']   tffcID=[' + convert(varchar,isnull(@tffcID,0)) +']'


--set @strLog = "consume1 pid=" + @@SPID + " prodorder=[" + @ProdOrder +"]  acsserial=[" + @acsserial +"] usedserial=["+ @usedserial +"]   tffcID=[" + @tffcID +"]"

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
set @success='OK'
end
else
begin
   if exists
    (
   select TFFC_ID from TFFC_SerialNumbers WITH (TABLOCKX)  where TFFC_ProdOrder = rtrim(@ProdOrder) and  TFFC_Reserved = 1 and TFFC_Reservedby = rtrim(@acsserial)
     )
     begin
 --          select TFFC_ID from TFFC_SerialNumbers where TFFC_ProdOrder = rtrim(@ProdOrder) and  TFFC_Reserved = 1 and TFFC_Reservedby = rtrim(@acsserial)
 --          update TFFC_SerialNumbers set TFFC_Reserved = 0,  TFFC_Consumed=0,TFFC_Reservedby='' where TFFC_ID = @tffcid
-- changed above two line to line below to help fix the multiple psc serial numbers per traveler issue 06/26/2012 WKurth
           update TFFC_SerialNumbers set TFFC_Reserved = 0,  TFFC_Consumed=0,TFFC_Reservedby='' where  TFFC_ProdOrder = rtrim(@ProdOrder) and  TFFC_Reserved = 1 and TFFC_Reservedby = rtrim(@acsserial)
    select @pscsn = psc_serial from [ACSEEState].[dbo].loci where acs_serial = @acsserial
    if @pscsn is not null
    begin
       update [ACSEESTate].[dbo].loci set psc_serial='' where acs_serial = @acsserial
    end

        set @strLog1 = 'unreserve3 pid=' + convert(varchar, @@SPID) + ' prodorder=[' + isnull(@ProdOrder,'') +']  acsserial=[' + isnull(@acsserial,'') +']   tffcID=[' + convert(varchar,isnull(@tffcID,0)) +']'


--set @strLog = "consume1 pid=" + @@SPID + " prodorder=[" + @ProdOrder +"]  acsserial=[" + @acsserial +"] usedserial=["+ @usedserial +"]   tffcID=[" + @tffcID +"]"

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
            set @success = 'OK'
     end
     else
     begin
         set @success = 'NO'
     end
end
commit transaction
select @success as success
GO