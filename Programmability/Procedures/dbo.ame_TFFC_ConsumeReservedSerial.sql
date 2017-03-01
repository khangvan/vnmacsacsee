SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_ConsumeReservedSerial]
@ProdOrder char(20),
@acsserial char(20),
@material char(20),
@station char(20),
@usedserial char(20),
@serial char(20) OUTPUT
AS

	set nocount on

		declare @strLog char(300)
		declare @strLog2 char(300)
		declare @strLog3 char(300)

		declare @tffcID int

	begin transaction
		begin transaction	
			select @tffcID =  min(TFFC_ID) from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder 
			and TFFC_Reserved = 1 and TFFC_Reservedby=@acsserial and TFFC_SerialNumber = @usedserial
		commit transaction
--		set @strLog = 'consume1 pid=' + convert(varchar,@@SPID) + ' prodorder=[' + isnull(@ProdOrder,'') +']  acsserial=[' + isnull(@acsserial,'') +'] usedserial=['+ isnull(@usedserial,'') +']   tffcID=[' + convert(varchar,isnull(@tffcID,0)) +']'


--set @strLog = "consume1 pid=" + @@SPID + " prodorder=[" + @ProdOrder +"]  acsserial=[" + @acsserial +"] usedserial=["+ @usedserial +"]   tffcID=[" + @tffcID +"]"
/*   
insert into TFFC_ConsumeLog
(
LogTime,
LogRecord,
ACSSerial
)
values
(
getdate(),
@strLog,
@acsserial
)
 */
		begin transaction
			if @tffcID is not null
			begin
				begin transaction
					select @serial = TFFC_SerialNumber from TFFC_SerialNumbers where TFFC_ID = @tffcID
					update TFFC_SerialNumbers set TFFC_Consumed =1, TFFC_ConsumedDate = getdate(), TFFC_ACSSerial=@acsserial,  TFFC_StationConsumedAt = @station where TFFC_ID = @tffcID
				commit transaction
	--		set @strLog2 = 'consume2 pid=' + convert(varchar,@@SPID) + '   prodorder=[' + isnull(@ProdOrder,'') +']  acsserial=[' + isnull(@acsserial,'') +'] usedserial=['+ isnull(@usedserial,'') +']   tffcID=[' + convert(varchar,isnull(@tffcID,0)) +'] aserial=[' + isnull(@serial,'') + ']'
				begin transaction
					update [ACSEESTATE].[dbo].loci set psc_serial = @serial where acs_serial = @acsserial
				commit transaction
/*  
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
@strLog2,
@acsserial,
@serial
)
   */
			end
			else
			begin
				set @serial ='BAD'
			end
		commit transaction
/*
commit transaction

set @strLog3 = 'consume3 pid=' + convert(varchar,@@SPID) + '   prodorder=[' + isnull(@ProdOrder,'') +']  acsserial=[' + isnull(@acsserial,'') +'] usedserial=['+ isnull(@usedserial,'') +']   tffcID=[' + convert(varchar,isnull(@tffcID,0)) +'] aserial=[' + isnull(@serial,'') + ']'

insert into TFFC_ConsumeLog
(
LogTime,
LogRecord,
ACSSerial,
SAPSerial,
ReservedSerial
)
values
(
getdate(),
@strLog3,
@acsserial,
@serial,
@serial
)
*/
		select @serial as serial
	commit transaction
GO