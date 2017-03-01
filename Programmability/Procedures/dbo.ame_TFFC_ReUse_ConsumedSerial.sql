SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_ReUse_ConsumedSerial]
@ProdOrder char(20),
@usedserial char(20),
@acsserial char(20),
@material char(20),
@station char(20),
@serial char(20) OUTPUT,
@result char(20) OUTPUT

 AS

set nocount on


declare @tffcID int
declare @recProdOrder nchar(20)
declare @recserial char(20)
declare @recRefreshDate datetime
declare @recReserved int
declare @recReservedby char(20)
declare @recConsumed int
declare @recConsumedDate datetime
declare @recMaterial char(20)
declare @recDescription char(50)
declare @recAcsSerial char(20)
declare @recStationConsumed char(20)
declare @recPeriod char(20)

declare @currentTime datetime


declare @assemid int

begin transaction
select @tffcID =  min(TFFC_ID) from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder and TFFC_SerialNumber=@usedserial

if @tffcID is not null
begin


select @recProdOrder =TFFC_ProdOrder, @recserial= TFFC_SerialNumber ,
@recRefreshDate = TFFC_RefreshDate, @recReserved = TFFC_Reserved, @recReservedby =TFFC_Reservedby, 
@recConsumed = TFFC_Consumed, @recConsumedDate = TFFC_ConsumedDate, @recMaterial = TFFC_Material, 
@recDescription = TFFC_Description, @recAcsSerial = TFFC_ACSSErial, @recStationConsumed = TFFC_StationConsumedAt, 
@recPeriod = TFFC_Period
from TFFC_SerialNumbers where TFFC_ID = @tffcID

set @currentTime = getdate()

exec ame_TFFC_Record_LogHistory @recProdOrder, @recserial, @recRefreshDate, @recReserved, @recReservedby,
@recConsumed, @recConsumedDate, @recMaterial, @recDescription, @recAcsSerial, @recStationConsumed, @recPeriod,
@currentTime , 'REWORK', 'ame_TFFC_ReUse_ConsumedSerial'


update TFFC_SerialNumbers set TFFC_Consumed = 0, TFFC_ReservedBy = @acsserial, TFFC_AcsSerial= @acsserial ,TFFC_StationConsumedAt= @station
where TFFC_ID = @tffcID 

select @assemid = assem_ID from assemblies where psc_serial = @usedserial
if @assemid is not null
begin
   update assemblies set psc_serial = '' where assem_ID = @assemid
end

update ACSEEState.[dbo].loci set psc_serial = '' where acs_serial = @recAcsSerial


set @serial = @usedserial
set @result = 'OK'
end
else
begin
set @serial = 'NOT'
set @result='NOTFOUND'
end

commit transaction
select @serial as serial, @result as result
GO