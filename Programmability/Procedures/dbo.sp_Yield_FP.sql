SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[sp_Yield_FP] AS
-- Meant to be run as an Agent Job once per day
-- First format the date nicely
declare @ya datetime
declare @yo datetime
declare @iday int
declare @imonth int
declare @iyear int
declare @cdate char(10)
set @ya=getdate()
declare @St char(30)
declare @Sh char(5)
declare @PL char(20)
declare @Cum char(1)
declare @T int
declare @ORT int
declare @ps int
declare @StartDate datetime
declare @TodayDate datetime
declare @CD datetime
declare @Count int
set @Count =0
set @TodayDate = getdate()
set @StartDate=convert(datetime,'2/1/2002',101)
set @CD = @StartDate
set nocount on

set @CD = dateadd(day,-1,@TodayDate) --<<<Need to strip the time off
set @iday = datepart(day,@CD)
set @imonth = datepart(month,@CD)
set @iyear = datepart(year,@CD)
set @cdate = rtrim(convert(char(2),@imonth))+'/'+rtrim(convert(char(2),@iday))+'/'+convert(char(4),@iyear)
--select @cdate
set @yo = convert(datetime,@cdate,101)

     set @St = 'ViperPerformance1'
     exec sp_getyieldTotal @St,'SE',@CD,@Sh OUTPUT,
	@PL OUTPUT, @Cum OUTPUT, @T OUTPUT, @ORT OUTPUT,
	@ps OUTPUT
     if @T>0
	begin
     	   insert Yield_FP
     	   values(@yo,@Sh,@PL,@St,@Cum,@T,@ORT,@ps)
	end
    exec sp_getyieldTotal @St,'SG',@CD,@Sh OUTPUT,
	@PL OUTPUT, @Cum OUTPUT, @T OUTPUT, @ORT OUTPUT,
	@ps OUTPUT
     if @T>0
	begin
    	   insert Yield_FP
     	   values(@yo,@Sh,@PL,@St,@Cum,@T,@ORT,@ps)
	end
     set @St = 'ViperPerformance2'
     exec sp_getyieldTotal @St,'SE',@CD,@Sh OUTPUT,
	@PL OUTPUT, @Cum OUTPUT, @T OUTPUT, @ORT OUTPUT,
	@ps OUTPUT
     if @T>0
	begin
     	   insert Yield_FP
     	   values(@yo,@Sh,@PL,@St,@Cum,@T,@ORT,@ps)
	end
    exec sp_getyieldTotal @St,'SG',@CD,@Sh OUTPUT,
	@PL OUTPUT, @Cum OUTPUT, @T OUTPUT, @ORT OUTPUT,
	@ps OUTPUT
     if @T>0
	begin
    	   insert Yield_FP
     	   values(@yo,@Sh,@PL,@St,@Cum,@T,@ORT,@ps)
	end

     set @St = 'ViperCalibration1'
     exec sp_getyieldTotal @St,'SE',@CD,@Sh OUTPUT,
	@PL OUTPUT, @Cum OUTPUT, @T OUTPUT, @ORT OUTPUT,
	@ps OUTPUT
     if @T>0
	begin
     	   insert Yield_FP
     	   values(@yo,@Sh,@PL,@St,@Cum,@T,@ORT,@ps)
	end
     exec sp_getyieldTotal @St,'SG',@CD,@Sh OUTPUT,
	@PL OUTPUT, @Cum OUTPUT, @T OUTPUT, @ORT OUTPUT,
	@ps OUTPUT
     if @T>0
	begin
     	   insert Yield_FP
     	   values(@yo,@Sh,@PL,@St,@Cum,@T,@ORT,@ps)
	end

     set @St = 'RhinoFinalTest1'
     exec sp_getyieldTotal @St,'SR',@CD,@Sh OUTPUT,
	@PL OUTPUT, @Cum OUTPUT, @T OUTPUT, @ORT OUTPUT,
	@ps OUTPUT
     if @T>0
	begin
     	   insert Yield_FP
     	   values(@yo,@Sh,@PL,@St,@Cum,@T,@ORT,@ps)
	end

     set @St = 'RhinoFulFill1'
     exec sp_getyieldTotal @St,'SV',@CD,@Sh OUTPUT,
	@PL OUTPUT, @Cum OUTPUT, @T OUTPUT, @ORT OUTPUT,
	@ps OUTPUT
     if @T>0
	begin
     	   insert Yield_FP
     	   values(@yo,@Sh,@PL,@St,@Cum,@T,@ORT,@ps)
	end

       set @St = 'F4410WinCE1'
       exec sp_getyieldTotal @St,'SD',@CD,@Sh OUTPUT,
	@PL OUTPUT, @Cum OUTPUT, @T OUTPUT, @ORT OUTPUT,
	@ps OUTPUT
     if @T>0
	begin
    	   insert Yield_FP
     	   values(@yo,@Sh,@PL,@St,@Cum,@T,@ORT,@ps)
	end

     set @St = 'F4410FinalTest1'
     exec sp_getyieldTotal @St,'SD',@CD,@Sh OUTPUT,
	@PL OUTPUT, @Cum OUTPUT, @T OUTPUT, @ORT OUTPUT,
	@ps OUTPUT
     if @T>0
	begin
     	   insert Yield_FP
     	   values(@yo,@Sh,@PL,@St,@Cum,@T,@ORT,@ps)
	end

     set @St = 'F4410FulFill1'
     exec sp_getyieldTotal @St,'SW',@CD,@Sh OUTPUT,
	@PL OUTPUT, @Cum OUTPUT, @T OUTPUT, @ORT OUTPUT,
	@ps OUTPUT
     if @T>0
	begin
     	   insert Yield_FP
     	   values(@yo,@Sh,@PL,@St,@Cum,@T,@ORT,@ps)
	end

GO