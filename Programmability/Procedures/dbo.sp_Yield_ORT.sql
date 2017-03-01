SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[sp_Yield_ORT] AS
declare @Station char(30)
set @Station = 'ViperCalibration1'
declare @Shift char(5)
declare @ProdLine char(20)
declare @Cum char(1)
declare @total int
declare @ToORT int
declare @passed int
declare @yo datetime
declare @StartDate datetime
declare @TodayDate datetime
declare @CurrentDate datetime
declare @Counter int
declare @iday int
declare @imonth int
declare @iyear int
declare @cdate char(10)

set @Counter = 0
set @TodayDate = getdate()
set @StartDate=convert(datetime,'2/1/2002',101)
set @CurrentDate = @StartDate
set nocount on

set @CurrentDate = dateadd(day,-1,@TodayDate) --<<<Need to strip the time off
set @iday = datepart(day,@CurrentDate)
set @imonth = datepart(month,@CurrentDate)
set @iyear = datepart(year,@CurrentDate)
set @cdate = rtrim(convert(char(2),@imonth))+'/'+rtrim(convert(char(2),@iday))+'/'+convert(char(4),@iyear)
--select @cdate
set @yo = convert(datetime,@cdate,101)--while datediff(day,@CurrentDate,@TodayDate)>0
 --  begin
     exec sp_getyieldORTTotal @Station,@CurrentDate,
	'SE', @total OUTPUT, @passed OUTPUT
--select @Total,@passed 
    if @total>0
	begin
	--   set @Counter = @Counter +1
     	   insert Yield_ORT
     	   values(@yo,'Viper',@Station,@total,@passed)
	end
     exec sp_getyieldORTTotal @Station,@CurrentDate,
	'SG', @total OUTPUT, @passed OUTPUT
--select @Total,@passed 
    if @total>0
	begin
	--   set @Counter = @Counter +1
     	   insert Yield_ORT
     	   values(@yo,'Python',@Station,@total,@passed)
	end
 --    set @CurrentDate = dateadd(day,1,@CurrentDate)
--   end

--select @Counter

--select * from Yield_ORT
set @Station = 'ViperPerformance1'
     exec sp_getyieldORTTotal @Station,@CurrentDate,
	'SE', @total OUTPUT, @passed OUTPUT
--select @Total,@passed 
     if @total>0
	begin
   	   insert Yield_ORT
     	   values(@yo,'Viper',@Station,@total,@passed)
	end
     exec sp_getyieldORTTotal @Station,@CurrentDate,
	'SG', @total OUTPUT, @passed OUTPUT
--select @Total,@passed 
     if @total>0
	begin
   	   insert Yield_ORT
     	   values(@yo,'Python',@Station,@total,@passed)
	end
set @Station = 'ViperPerformance2'
     exec sp_getyieldORTTotal @Station,@CurrentDate,
	'SE', @total OUTPUT, @passed OUTPUT
--select @Total,@passed 
     if @total>0
	begin
   	   insert Yield_ORT
     	   values(@yo,'Viper',@Station,@total,@passed)
	end
     exec sp_getyieldORTTotal @Station,@CurrentDate,
	'SG', @total OUTPUT, @passed OUTPUT
--select @Total,@passed 
     if @total>0
	begin
   	   insert Yield_ORT
     	   values(@yo,'Python',@Station,@total,@passed)
	end
GO