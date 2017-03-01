SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FRUBatch_GetCounter]
@lookupkey1 char(20),
@lookupkey2 char(20),
@lookupkey3 char(20)
 AS
set nocount on

declare @fulldatetime datetime
declare @imonth int
declare @monthpart char(2)
declare @iyear int
declare @yearpart char(2)
declare @iday int
declare @daypart char(2)
declare @location char(1)
declare @icounter int
declare @strcounter char(2)

declare @frubatch_id int

declare @cdate char(20)
declare @returncode char(20)


declare @lastinsertid int

set @fulldatetime = getdate()



   set @iday = datepart(day,@fulldatetime)
   set @imonth = datepart(month, @fulldatetime)
   set @iyear = datepart(YY, @fulldatetime)

set @iyear = @iyear %100

 --   set @monthpart = rtrim(convert(char(2),@imonth))
 --   set @yearpart = rtrim(convert(char(2),@iyear))
 --   set @daypart = rtrim(convert(char(2),@iday))

   set @monthpart = RIGHT('00'+ CONVERT(VARCHAR,@imonth),2) 
   set @yearpart = RIGHT('00'+ CONVERT(VARCHAR,@iyear),2) 
   set @daypart =RIGHT('00'+ CONVERT(VARCHAR,@iday),2) 


 --  set @cdate = rtrim(convert(char(2),@imonth))+'/'+rtrim(convert(char(2),@iday)) + '/'+convert(char(4),@iyear)
 --  set @pastDate = convert(datetime,@cdate,101)   

    select @frubatch_id = FRUBatch_ID from FruBatchCounters where @yearpart = FRUBatch_year and @monthpart = FRUBatch_Month and @daypart=FRUBatch_Day
   if  @frubatch_id is null
   begin
print 'found it'
       insert into FruBatchCounters
       (
	FRUBatch_LocationPrefix, FRUBatch_Date, 
	FRUBatch_Year, FRUBatch_Month, FRUBatch_Day, 
	Key1, Key2, Key3, 
	FRUBatch_Counter
       )
      values
       (
           'F',@fulldatetime,
           @yearpart, @monthpart, @daypart,
           @lookupkey1, @lookupkey2, @lookupkey3,
           0  
       )
       set @frubatch_id = @@IDENTITY
   end

print 'got frubatch'
print @frubatch_id

select @icounter = FRUBatch_counter, @location = FRUBatch_LocationPrefix from FruBatchCounters where FRUBatch_ID = @frubatch_id
set @icounter = 0
update FruBatchCounters set FRUBatch_counter = @icounter where FRUBatch_ID = @frubatch_id
--set @icounter = 0

set @strcounter = RIGHT('00'+ CONVERT(VARCHAR,@icounter),2) 
   set @returncode =@location +  @yearpart + @monthpart + @daypart + @strcounter

select @returncode
GO