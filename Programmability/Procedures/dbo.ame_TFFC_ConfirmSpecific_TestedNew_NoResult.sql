﻿SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_ConfirmSpecific_TestedNew_NoResult]
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

declare @doubleTestid int

set @station=''
set @passfail=''
set @OK='BAD'

/*   code for previous station verification wether base or subassembly - Bill Kurth*/
-- in this way it works always
if substring(@partnumber,1,2)='74' or substring(@partnumber,1,1)='5' 
begin
	if exists ( select acs_serial from [ACSEEState].[dbo].loci where acs_serial = @acsserial  and sap_model=@partnumber and ( next_station_name='ACSVNONESTART' OR next_station_name='PRINTPACK'))
	begin
		set @OK = 'OK' -- found loci entry at start station
		set @passfail = 'P' -- so result is P
		set @station =''
	end
	else
	begin
		set @OK='BAD'  -- didn't find any loci entry at start station
		set @passfail='F' -- we should presume the test was fail
		set @station=''
	end
end
else
begin
	if exists ( select acs_serial from  [ACSEEState].[dbo].loci where acs_serial=@acsserial and sap_model=@partnumber and next_station_name='TMPostTest')
	begin
	--*/
		set @OK = 'OK' -- found loci entry at TMPostTest
		set @passfail = 'P'  -- so result is P
		set @station =''
	end
	else
	begin
		set @OK='BAD'  -- didn't find any loci entry at TMPostTest
		set @passfail='F' -- we should presume the test was fail
		set @station=''
	end
end

if (@OK='BAD')  -- no loci entry was found so I have to look some where else
begin

	select @kicksubid = TFFC_KickSub_ID from TFFC_KickSub where TFFC_KickSub_model = @sapmodel and TFFC_KickSub_Part= @partnumber
	if @kicksubid is not null 
	begin
		select @kicksubstation = TFFC_KickSub_Station, @kicksublocation = TFFC_KickSub_Location 
		from TFFC_KickSub 
		where TFFC_KickSub_ID = @kicksubid

		if rtrim(@kicksublocation) = 'Local'
		begin
			select @doubleTestid= max(DT_id) from TM_DoubleTestTable where DT_Model=@partnumber

			if @doubleTestid is null
			begin
				select @lasttlid = max(TL_ID) from testlog where sap_model = @partnumber and acs_serial = @acsserial
				if @lasttlid is not null
				begin
					select @station = station, @passfail = pass_fail from testlog where tl_id = @lasttlid
					if rtrim(@passfail) = 'P'
					begin
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
					else -- passfail <> P
					begin
						set @OK = 'BAD'
					end
				end
			end
			else
			begin --doubleTestid is not null but OK='BAD' the subassembly is local, the subassembly has more than 1 final test but no information is in loci --> the information is not complete
				set @OK='BAD'  
				set @passfail='F' 
				set @station=''	
			end
		end
		else -- overseas
		begin
			set @OK = 'OK' -- no check because is overseas
			set @passfail = 'P' -- so result is P
			set @station =''
		end
	end
	else
	begin  -- No infomation found on the database about this unit, one of the parameter is wrong, or simply the unit has never been tested
	   set @OK = 'BAD'
	   set @passfail = 'F'
	   set @station =''
	end
	--select @subcomponentserial = scanned_serial from asylog inner join catatlog on adde_part_no = part_no_count where acs_serial = @acsserial and added_part_no_name = @partnumber

end

--select @acsserial as serial, @partnumber as partnumber, @station as station, @passfail as passfail, @OK as ok
GO