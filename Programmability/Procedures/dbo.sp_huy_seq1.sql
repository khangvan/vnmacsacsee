SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_huy_seq1]
	@station char(30) = NULL,
	@dt smalldatetime = NULL
	
AS
	set nocount on

	declare @dt1 char(19)
	declare @dt2 char(19)

	declare @total1 int
	declare @pass1 int
	declare @rpass1 int

	declare @acs_serial char(30)
	declare @subtest_name char(30)
	declare @strvalue char(30)

	set @dt1=CONVERT(char(11), DATEADD(day, 0, @dt), 101)
	set @dt2=CONVERT(char(11), DATEADD(day, 7, @dt), 101)

	select @total1=count(distinct acs_serial) from testlog
	where
	station=@station
	and test_date_time > @dt1
	and test_date_time < @dt2
	and firstrun='y'

	select @pass1=count(distinct acs_serial) from testlog
	where
	station=@station
	and test_date_time > @dt1
	and test_date_time < @dt2
	and firstrun='y'
	and pass_fail='p'

	select @rpass1=count(distinct acs_serial) from testlog
	where
	acs_serial in (
	select acs_serial from testlog
	where
	station=@station
	and test_date_time > @dt1
	and test_date_time < @dt2
	and firstrun='y'
	and pass_fail='f')
	and station=@station
	and test_date_time > @dt1
	and test_date_time < @dt2
	and pass_fail='p'

	set @rpass1=@pass1+@rpass1

	insert tmpFPY (Station,Total,Pass,RPass,FromDate)
	values (@station,@total1,@pass1,@rpass1,@dt1)

	insert tmpFailure (ACS_Serial,SubTest_Name,strValue,Station,TID)
	select ACS_Serial,SubTest_Name,strValue,Station,STL_ID from subtestlog
	where
	acs_serial in (
	select acs_serial from testlog
	where
	station=@station
	and test_date_time > @dt1
	and test_date_time < @dt2
	and firstrun='y'
	and pass_fail='f')
	and pass_fail='f'
	order by stl_id

	declare pointer Cursor for select ACS_Serial,SubTest_name,strValue from tmpFailure where Station=@station order by TID
	open pointer
	fetch next from pointer into @acs_serial,@subtest_name,@strvalue
	while (@@FETCH_STATUS <> -1)
	begin
		if not exists (select ACS_Serial from tmpFailure1 where ACS_Serial=@acs_serial)
		begin
			insert tmpFailure1 (Station,ACS_Serial,SubTest_Name,strValue) values (@station,@acs_serial,@subtest_name,@strvalue)
		end
		fetch next from pointer into @acs_serial,@subtest_name,@strvalue
	end
	close pointer
	deallocate pointer
GO