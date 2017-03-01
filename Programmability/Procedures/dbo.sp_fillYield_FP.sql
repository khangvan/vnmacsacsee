SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


CREATE proc [dbo].[sp_fillYield_FP]
-- Define input parameters
-- Define code
AS
declare @Station char(30)
set @Station = 'ViperPerformance1'
declare @Shift char(5)
declare @ProdLine char(20)
declare @Cum char(1)
declare @total int
declare @ToORT int
declare @passed int
declare @StartDate datetime
declare @TodayDate datetime
declare @CurrentDate datetime
declare @Count int
set @Count =0
set @TodayDate = getdate()
set @StartDate=convert(datetime,'2/1/2002',101)
set @CurrentDate = @StartDate
set nocount on

set @CurrentDate = dateadd(day,-1,@TodayDate) --<<<Need to strip the time off
--while datediff(day,@CurrentDate,@TodayDate)>0
 --  begin
     exec sp_getyieldTotal @Station,@CurrentDate,@Shift OUTPUT,
	@ProdLine OUTPUT, @Cum OUTPUT, @total OUTPUT, @ToORT OUTPUT,
	@passed OUTPUT
     if @total>0
	begin
--	   set @Count = @Count +1
     	   insert Yield_FP
     	   values(@CurrentDate,@Shift,@ProdLine,@Station,@Cum,@total,@ToORT,@passed)
	end
--     set @CurrentDate = dateadd(day,1,@CurrentDate)
  -- end
--select @Count


/* now do the other test station on Viper */
set @Station = 'ViperCalibration1'
     exec sp_getyieldTotal @Station,@CurrentDate,@Shift OUTPUT,
	@ProdLine OUTPUT, @Cum OUTPUT, @total OUTPUT, @ToORT OUTPUT,
	@passed OUTPUT
     if @total>0
	begin
--	   set @Count = @Count +1
     	   insert Yield_FP
     	   values(@CurrentDate,@Shift,@ProdLine,@Station,@Cum,@total,@ToORT,@passed)
	end


GO