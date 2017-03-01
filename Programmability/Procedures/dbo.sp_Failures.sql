SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[sp_Failures] AS
-- fill failures
declare @yo datetime
declare @iday int
declare @imonth int
declare @iy int
declare @cdate char(10)

declare @Station char(30)
set @Station = 'ViperProgramming1'
declare @TestDate as datetime
set @TestDate = convert(datetime,'2/1/2002',101)
declare @ProdLine char(10)
set @ProdLine = 'PCB'
declare @CurrentDate datetime
declare @TodayDate datetime
set @TodayDate=getdate()
set @CurrentDate = dateadd(day,-1,@TodayDate)
set @iday = datepart(day,@CurrentDate)
set @imonth = datepart(month,@CurrentDate)
set @iy = datepart(year,@CurrentDate)
set @cdate = rtrim(convert(char(2),@imonth))+
	'/'+rtrim(convert(char(2),@iday))+'/'+convert(char(4),@iy)
set @yo = convert(datetime,@cdate,101)

select 'Set up'
set nocount on
--while datediff(day, @TestDate,@TodayDate)>0
--   begin
	--insert Failures
	--exec sp_getSubtestYield @ProdLine,@Station, @yo
--   	set @TestDate = dateadd(day,1,@TestDate)
--   end
insert Failures
exec sp_getSubtestYield 'Mamba','PCBLine', 'MAMBAANALOG1', @yo

select 'MambaAnnalog1'

insert Failures
exec sp_getSubtestYield 'Mamba','PCBLine', 'MAMBAPROGRAMMING1', @yo

select 'MambProgramming1'
insert Failures
exec sp_getSubtestYield 'Viper','PCBLine', 'ViperAnalog1', @yo

select 'ViperAnalaog1'
insert Failures
exec sp_getSubtestYield 'Viper','ViperLine', 'ViperCalibration1', @yo
insert Failures
exec sp_getSubtestYield 'Python','ViperLine', 'ViperCalibration1', @yo

select 'ViperCal'

insert Failures
exec sp_getSubtestYield 'Viper','PCBLine', 'ViperDigital1', @yo
select 'ViperDig'
insert Failures
exec sp_getSubtestYield 'Viper','PCBLine', 'ViperInterface1', @yo
select 'ViperInter'
insert Failures
exec sp_getSubtestYield 'Viper','ViperLine', 'ViperPerformance1', @yo
insert Failures
exec sp_getSubtestYield 'Python','ViperLine', 'ViperPerformance1', @yo
insert Failures
exec sp_getSubtestYield 'Viper','ViperLine', 'ViperPerformance2', @yo
insert Failures
exec sp_getSubtestYield 'Python','ViperLine', 'ViperPerformance2', @yo

select 'Viperperform'
insert Failures
exec sp_getSubtestYield 'Viper','PCBLine', 'ViperProgramming1', @yo

select 'viperprog'
insert Failures
exec sp_getSubtestYield 'Rhino','PCBLine', 'RHINOANALOG1', @yo
insert Failures
exec sp_getSubtestYield 'Rhino','PCBLine', 'RhinoProgramming1', @yo

insert Failures
exec sp_getSubtestYield 'Rhino','RhinoLine', 'RhinoFinalTest1', @yo
--select 'ViperDig'
insert Failures
exec sp_getSubtestYield 'Rhino','RhinoLine', 'RhinoFulFIll1', @yo
  -- 	set @TestDate = dateadd(day,1,@TestDate)

--   end
--select * from Failures order by Test_Station
select 'all done'
GO