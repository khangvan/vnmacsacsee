SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TestSubtestsExist]
 AS
set nocount on

declare @TodayDate datetime
declare @pastDate datetime
declare @pastDatePlusOne datetime
declare @iday int
declare @imonth int
declare @iyear int
declare @cdate char(10)

select count(*) from subtestlimits

set @TodayDate = getdate()
   set @iday = datepart(day,@TodayDate)
   set @imonth = datepart(month, @TodayDate)
   set @iyear = datepart(year, @TodayDate)
   set @cdate = rtrim(convert(char(2),@imonth))+'/'+rtrim(convert(char(2),@iday)) + '/'+convert(char(4),@iyear)
   set @pastDate = convert(datetime,@cdate,101)   


--print @pastDate


select count(*) from [ACSEEClientState].[dbo].parts_level where BOM_Date_time > @pastDate
GO