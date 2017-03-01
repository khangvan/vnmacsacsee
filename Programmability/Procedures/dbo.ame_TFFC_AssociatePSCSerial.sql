SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_AssociatePSCSerial]
@station char(20),
@model char(20),
@serial char(20),
@PSCSerial char(20),
@ResultState char(80) OUTPUT
 AS
set nocount on


declare @prodorder char(20)
declare @TFFC_Record_ID int


select @prodorder = ProdOrder from [ACSEESTate].[dbo].loci where acs_serial = @serial
if @prodorder is not null
begin
    select @TFFC_Record_ID =  TFFC_ID from TFFC_SerialNumbers where TFFC_ProdOrder = @prodorder and TFFC_SerialNumber = @PSCSerial 
    if @TFFC_Record_ID is not null
    begin
       update TFFC_SerialNumbers set tffc_reservedby = @serial, tffc_reserved=1, tffc_consumed = 1, tffc_consumeddate=getdate(), TFFC_StationConsumedAt = @station where  TFFC_ID = @TFFC_Record_ID
       update [ACSEEState].[dbo].loci set PSC_Serial = @PSCSerial where acs_serial = @serial 

       set @ResultState = 'OK'
    end
    else
    begin
            set @ResultState = 'Serial number not found in production order'
    end
end
else
begin
   set @ResultState = 'ACS Serial not associated with Production Oorder'
end

select @ResultState as ResultState
GO