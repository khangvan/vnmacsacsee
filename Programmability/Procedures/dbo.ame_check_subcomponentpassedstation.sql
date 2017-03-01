SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_check_subcomponentpassedstation]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@pname		char(20) = NULL, -- Part_No_Name (in Catalog db)
	@sname		char(20) = NULL, -- Station_Name (from Stations db)
	@sserial	char(20) = NULL
AS
set nocount on

declare @componentserial char(20)
declare @componentacsserial char(20)
declare @lasttestdatetime datetime
declare @passfaillast char(3)


 if exists ( select scanned_serial from asylog
inner join catalog on added_part_no = part_no_count
where acs_serial =@aserial  
and part_no_name=@pname  )
begin
	select @componentserial = scanned_serial from asylog
	inner join catalog on added_part_no = part_no_count
	where acs_serial =@aserial  
	and part_no_name=@pname  

    

	select @componentacsserial = acs_serial from [ACSEEState].[dbo].loci where psc_serial = @componentserial

	select @lasttestdatetime = max(test_date_time) from testlog where acs_serial= @componentacsserial and station = @sname


	select @passfaillast = pass_fail from testlog where acs_serial= @componentacsserial and station = @sname and test_date_time = @lasttestdatetime	

	if  @passfaillast = 'P'
	begin
		select 'OK'
	end
	else
	begin
		select 'FAILED'
	end
end
else
begin
	select 'NONE'
end
GO