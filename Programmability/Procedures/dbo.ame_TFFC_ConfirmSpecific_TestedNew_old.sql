SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_ConfirmSpecific_TestedNew_old]
@acsserial char(20),
@partnumber char(20),
@sapmodel char(20),
@station char(20) OUTPUT,
@passfail char(20) OUTPUT,
@OK char(20) OUTPUT
 AS
set nocount on

declare @kicksubid int
declare @kicksubmodel char(20)
declare @kicksubpart char(20)
declare @kicksubstation char(20)
declare @kicksublocation char(20)
declare @lasttlid int
declare @charpos int

set @station=''
set @passfail=''
set @OK='BAD'

select @kicksubid = TFFC_KickSub_ID from TFFC_KickSub where TFFC_KickSub_model = @sapmodel and TFFC_KickSub_Part= @partnumber
if @kicksubid is not null
begin
    select @kicksubstation = TFFC_KickSub_Station, @kicksublocation = TFFC_KickSub_Location from TFFC_KickSub where TFFC_KickSub_ID = @kicksubid
     if rtrim(@kicksublocation) = 'Local'
     begin
--catch follow last Test_Date_Time
declare @dt datetime
select @dt = max(Test_Date_Time) from testlog where sap_model = @partnumber and acs_serial = @acsserial
select @lasttlid = max(TL_ID) from testlog where Test_Date_Time=@dt and sap_model = @partnumber and acs_serial = @acsserial
--end
           --select @lasttlid = max(TL_ID) from testlog where sap_model = @partnumber and acs_serial = @acsserial
	if @lasttlid is not null
	begin
    		select @station = station, @passfail = pass_fail from testlog where tl_id = @lasttlid and station not like 'G2DPOWER%' and station not like 'DRAGONLCAL%'
                           if rtrim(@passfail) = 'P'
                           begin
--don't check station cause we only need exist data on server
			 set @OK = 'OK'
		end
/*
                           set @charpos =charindex(rtrim(@kicksubstation), @station)
                           if @charpos is not null
                           begin
                               if @charpos > 0 
                               begin
                                       set @OK = 'OK'
                               end
                               else
                               begin
                                      set @OK = 'BAD'
                               end
                           end
                           else
                           begin
                                  set @OK = 'BAD'
                           end
                           end
*/
                            else -- passfail <> P
                            begin
                                  set @OK = 'BAD'
                            end
             end
     end
     else
      begin
           set @OK = 'OK'
           set @passfail = 'P'
           set @station =''
      end
end
else
begin
   set @OK = 'OK'
   set @passfail = 'P'
   set @station =''
end

--select @subcomponentserial = scanned_serial from asylog inner join catatlog on adde_part_no = part_no_count where acs_serial = @acsserial and added_part_no_name = @partnumber



select @acsserial as serial, @partnumber as partnumber, @station as station, @passfail as passfail, @OK as ok
GO