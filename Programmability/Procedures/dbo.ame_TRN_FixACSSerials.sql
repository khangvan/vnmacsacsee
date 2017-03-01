SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TRN_FixACSSerials]
 AS
set nocount on

declare @oldacsserial char(20)
declare @newacsserial char(20)
declare @oldacsserialtwo char(20)
declare @newacsserialtwo char(20)
declare @rowid int



declare curTestlog  CURSOR FOR
select ACS_Serial, TL_ID
from TRN_testlog where substring(acs_serial,1,3) = 'SMH'



declare cursubTestlog  CURSOR FOR
select ACS_Serial,  STL_ID
from TRN_subtestlog where substring(acs_serial,1,3) = 'SMH'


declare curAssemblies  CURSOR FOR
select ACS_Serial,  assem_ID
from TRN_assemblies 
inner join TRN_Stage_Tffc_Serialnumbers 
on TRN_Assemblies.acs_serial = TRN_Stage_TFFC_SerialNumbers.tffc_reservedby
where substring(acs_serial,1,3) = 'SMH'



declare curAsylog  CURSOR FOR
select ACS_Serial,  asylog_ID
from TRN_asylog 
inner join TRN_Stage_Tffc_Serialnumbers 
on TRN_Asylog.acs_serial = TRN_Stage_TFFC_SerialNumbers.tffc_reservedby
where substring(acs_serial,1,3) = 'SMH'





declare curTFFCSerials  CURSOR FOR
select  TFFC_Reservedby, 
TFFC_ACSSErial, TFFC_ID
from TRN_Stage_TFFC_SerialNumbers where substring(TFFC_Reservedby,1,3) = 'SMH'


open curTestlog
fetch next from curTestlog into @oldacsserial,@rowid
WHILE @@fetch_status = 0
begin
set @newacsserial = 'SMR' + substring(@oldacsserial,4,len(@oldacsserial) - 3)
update TRN_testlog set acs_serial = @newacsserial where TL_ID = @rowid
fetch next from curTestlog into @oldacsserial,@rowid
end
close curTestLog
deallocate curTestLog



open cursubTestlog
fetch next from cursubTestlog into @oldacsserial,@rowid
WHILE @@fetch_status = 0
begin
set @newacsserial = 'SMR' + substring(@oldacsserial,4,len(@oldacsserial) - 3)
update TRN_subtestlog set acs_serial = @newacsserial where STL_ID = @rowid
fetch next from cursubTestlog into @oldacsserial,@rowid
end
close cursubTestLog
deallocate cursubTestLog



open curAssemblies
fetch next from curAssemblies into @oldacsserial,@rowid
WHILE @@fetch_status = 0
begin
set @newacsserial = 'SMR' + substring(@oldacsserial,4,len(@oldacsserial) - 3)
update TRN_assemblies set acs_serial = @newacsserial where assem_id = @rowid
fetch next from curAssemblies into @oldacsserial,@rowid
end
close curAssemblies
deallocate curAssemblies





open curAsylog
fetch next from curAsylog into @oldacsserial,@rowid
WHILE @@fetch_status = 0
begin
set @newacsserial = 'SMR' + substring(@oldacsserial,4,len(@oldacsserial) - 3)
update TRN_asylog set acs_serial = @newacsserial where asylog_id = @rowid
fetch next from curAsylog into @oldacsserial,@rowid
end
close curAsylog
deallocate curAsylog





open curTFFCSerials
fetch next from curTFFCSerials into @oldacsserial, @oldacsserialtwo, @rowid
WHILE @@fetch_status = 0
begin
set @newacsserial = 'SMR' + substring(@oldacsserial,4,len(@oldacsserial) - 3)
set @newacsserialtwo = 'SMR' + substring(@oldacsserialtwo,4,len(@oldacsserialtwo) - 3)
update TRN_Stage_TFFC_SerialNumbers set TFFC_Reservedby = @newacsserial, TFFC_ACSSerial=@newacsserial where TFFC_id = @rowid
fetch next from curTFFCSerials into @oldacsserial,@oldacsserialtwo,@rowid
end
close curTFFCSerials
deallocate curTFFCSerials
GO