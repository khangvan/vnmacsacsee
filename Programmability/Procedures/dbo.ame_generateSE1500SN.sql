SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_generateSE1500SN]
@SN char(9) OUTPUT
 AS
/* wk get rid of se1500 F format
declare @year as char(2)
declare @month as char
declare @nextdigit as integer
declare @TodayDate datetime
declare @iday int
declare @imonth int
declare @iyear int
declare @workingsn char(9)
declare @week int
declare @serweek int
declare @sernumber int
declare @workingnumber char(9)
declare @sermonth int
get rid of se1500 F format */



	set nocount on
	declare @count int
	declare @countModel int
	declare @stamp datetime
	declare @SerialType char(1)
	declare @MCType char(1)
	declare @DatePart char(5)
	declare @Temp char(10)
	declare @NumDays int
	declare @strNumDays char(3)
	declare @LastDate datetime
	declare @LastModelDate datetime
	declare @DateImbeddedCounter char(8)
	declare @ModelImbeddedCounter char(3)
	declare @CustomFormat char(20)

             declare @endsn char(20)
	-- Initialize variables
	set @count =0
	set @stamp = getdate()
	set @ModelImbeddedCounter='000'
	set @DateImbeddedCounter='00000000'

	begin transaction
	-- Increment Counter for code in the Counters db
	select 
		@SerialType = Imbedded_Date,
		@count = Counter + 1,
		@LastDate = Last_Event_Date,
		@MCType = Imbedded_ModelCounter,
		@CustomFormat = strFormat
	from 
		[ACSEESTATE].dbo.Serialization (updlock)
	where  
		(Prefix_Type = 'ACS')
		and
		(Prefix = '8') -- Last_foo_Count
	if @@ERROR <> 0
	   Begin
		Rollback
		select 'Error Reading counter'
		return 
	   End

	--Check the date to see if counter needs to be set to zero first
	if @LastDate is not null and (@SerialType is not null and @SerialType <> '0' and @SerialType <>'N')
	   begin
		if datediff(dd, @LastDate, @stamp) > 0
		   begin
			set @count = 1
		   end
	   end

	--perform updates
	update
		[ACSEESTATE].dbo.Serialization
	set
		Counter = @count,
		Last_Event_Date = @stamp
	where  
		(Prefix_Type = 'ACS')
		and
		(Prefix = '8') -- Last_foo_Count

	if @@ERROR <> 0
	   	Begin
			Rollback		
			select 'Error updating counter'
			Return
	   	End
	else
		begin
			Commit
                                        set @endsn = 'S80' +convert(char(10), @count)
			select @endsn
			set @SN = @endsn	
		end
/*wk get rid of se1500 F format
declare @testsn char(9)

set @TodayDate = getdate()
   set @iday = datepart(day,@TodayDate)
   set @imonth = datepart(month, @TodayDate)
   set @iyear = datepart(year, @TodayDate)

set @week = datepart(wk,@TodayDate)


if (@iyear - 2000) < 10
begin
set @workingsn='F' +'0'+convert(char(2),@iyear-2000)
end
else
begin
set @workingsn='F' +convert(char(2),@iyear-2000)
end

if @imonth = 1
begin
   set @month='A'
end



if @imonth = 2
begin
   set @month='B'
end


if @imonth = 3
begin
   set @month='C'
end


if @imonth = 4
begin
   set @month='D'
end


if @imonth = 5
begin
   set @month='E'
end


if @imonth = 6
begin
   set @month='F'
end


if @imonth = 7
begin
   set @month='G'
end


if @imonth = 8
begin
   set @month='H'
end


if @imonth = 9
begin
   set @month='I'
end


if @imonth = 10
begin
   set @month='L'
end


if @imonth = 11
begin
   set @month='M'
end


if @imonth = 12
begin
   set @month='N'
end




set @workingSN = rtrim(@workingSN) + @month

print @week


select @sernumber = SER_Number from SK_Serialization
select @serweek = SER_CurrentWeek from SK_Serialization

select @sermonth = SER_CurrentMonth from SK_Serialization

get rid of se1500 F format wk*/
/* 
if @serweek != @week
begin
   update SK_Serialization set SER_CurrentWeek = @week
   update SK_Serialization set SER_Number = 1001
   set @sernumber = 1001
   set @serweek = @week
end
*/


/*wk get rid of se1500 F format
if @sermonth != @imonth
begin
   update SK_Serialization set SER_CurrentMonth = @imonth
   update SK_Serialization set SER_Number = 1001
   set @sernumber = 1001
   set @sermonth = @imonth
end

if @sernumber < 10000
begin
set @workingnumber = '0' + convert(char(4),@sernumber)
end
else
begin
set @workingnumber = convert(char(5),@sernumber)
end


set @sernumber = @sernumber + 1

update Sk_Serialization set SER_Number = @sernumber


set @SN=rtrim(@workingSN) + @workingnumber
get rid of se1500 F format wk*/
GO