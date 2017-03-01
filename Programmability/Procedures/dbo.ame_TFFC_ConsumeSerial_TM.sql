SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_ConsumeSerial_TM]
@ProdOrder char(20),
@acsserial char(20),
@material char(20),
@station char(20),
@SapSerial char(20) ,
@success char(20) OUTPUT
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
  from tffc_serialnumbers WITH (TABLOCKX) 
  where rtrim(TFFC_ProdOrder) = rtrim(@ProdOrder) and 
     rtrim(tffc_reservedby) = rtrim(@acsserial)
    
  if @usedtffcID is not null
   begin
    select @success = tffc_serialnumber 
    from tffc_serialnumbers 
    where tffc_id = @usedtffcID
   end
  else
   begin
    set @success = 'BAD'
    
    select @tffcID =  TFFC_ID 
    from TFFC_SerialNumbers 
    where rtrim(TFFC_ProdOrder) = rtrim(@ProdOrder) and 
       rtrim(TFFC_SerialNumber) = rtrim(@SapSerial) and 
       TFFC_Consumed = 0 and TFFC_Reserved = 0

    if @tffcID is not null
    begin
     update TFFC_SerialNumbers 
     set TFFC_Consumed =1, 
      TFFC_ConsumedDate = getdate(), 
      TFFC_ACSSerial=rtrim(@acsserial),  
      TFFC_StationConsumedAt = rtrim(@station), 
      TFFC_Reserved=1
     where TFFC_ID = @tffcID

     set @success ='OK'
    end
    else
     begin
      set @success ='BAD'
     end
   end
 end
else
 begin
 -- sbarozzi change on 2011-06-20
 -- in this case the ACSserial is not part of the PO-material or the ACSserial does not exists
  set @success ='BAD'
 end

commit transaction

select @success as success
GO