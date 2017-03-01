SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
create PROCEDURE [dbo].[ame_TFFC_ReserveSerialTM_Sep302016]
/*
Cause ACS VN down because this sp
Kvan, Huy add commit transtaction to acs performance smotht

*/
@ProdOrder char(20),
@acsserial char(20),
@material char(20),
@station char(20),
@serial char(20) OUTPUT
AS

set nocount on

declare @tffcID int
declare @usedtffcID int
declare @lociacsserial char(20)

begin transaction
-- sbarozzi change on 2011-06-20
-- check the ACSserial, ProdOrder and Material
select @lociacsserial = ACS_Serial
from [ACSEEState].[dbo].loci WITH (TABLOCKX) 
where ProdOrder=rtrim(@ProdOrder) and SAP_Model=rtrim(@material) and ACS_Serial=rtrim(@acsserial)

if @lociacsserial is not null
 begin
  select @usedtffcID = tffc_id 
  from tffc_serialnumbers  WITH (TABLOCKX) 
  where rtrim(TFFC_ProdOrder) = rtrim(@ProdOrder) and
   rtrim(tffc_reservedby) = rtrim(@acsserial)

  if @usedtffcID is not null
   begin
     select @serial = tffc_serialnumber 
     from tffc_serialnumbers 
     where tffc_id = @usedtffcID
   end
  else
   begin
    select @tffcID = min(TFFC_ID) 
    from TFFC_SerialNumbers 
    where TFFC_ProdOrder = rtrim(@ProdOrder) and 
      TFFC_Consumed = 0 and 
      TFFC_Reserved = 0

    if @tffcID is not null
     begin
      select @serial = TFFC_SerialNumber 
      from TFFC_SerialNumbers 
      where TFFC_ID = @tffcID
      
      update TFFC_SerialNumbers 
      set TFFC_Reserved =1, 
       TFFC_Reservedby=rtrim(@acsserial)
      where TFFC_ID = @tffcID
     end
    else
     begin
      set @serial ='BAD'
      if exists (
        select TFFC_ID 
        from TFFC_SerialNumbers 
        where TFFC_ProdOrder = rtrim(@ProdOrder))
       begin
        set @serial='FUL'
       end
     end
   end
 end
else
 begin
 -- sbarozzi change on 2011-06-20
 -- in this case the ACSserial is not part of the PO-material or the ACSserial does not exists
  set @serial ='BAD'
 end
commit transaction
select @serial as serial
GO