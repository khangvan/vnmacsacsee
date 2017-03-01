SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_ConfirmSpecific_Tested]
@acsserial char(20),
@partnumber char(20),
@station char(20) OUTPUT,
@passfail char(20) OUTPUT,
@OK char(20) OUTPUT
 AS
set nocount on


declare @lasttlid int

set @station=''
set @passfail=''
set @OK='BAD'


--select @subcomponentserial = scanned_serial from asylog inner join catatlog on adde_part_no = part_no_count where acs_serial = @acsserial and added_part_no_name = @partnumber
select @lasttlid = max(TL_ID) from testlog where sap_model = @partnumber and acs_serial = @acsserial

if @lasttlid is not null
begin
    select @station = station, @passfail = pass_fail from testlog where tl_id = @lasttlid

     set @OK = 'OK'

  
end
else
begin
set @OK = 'BAD'

end


select @acsserial as serial, @partnumber as partnumber, @station as station, @passfail as passfail, @OK as ok
GO