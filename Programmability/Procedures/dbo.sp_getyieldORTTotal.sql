SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


CREATE proc [dbo].[sp_getyieldORTTotal]
-- Define input parameters
	@Station varchar(30),
	@ORT_Complete datetime,
	@Prefix char(2),
	@total int OUTPUT,
	@passed int OUTPUT

-- Define code
AS


CREATE TABLE #tmpORTLog (
	[ACS_Serial] [char] (20) NOT NULL ,
	ORT_Complete_Date datetime NULL ,
	Test_Date_Time datetime NULL ,
	Test_Station char(30) NULL,
	[Pass_Fail] [char] (3) NULL
)

set nocount on

--insert #tmpORTLog
--exec sp_getyieldORTRaw 'ViperPerformance1'

insert #tmpORTLog
exec sp_getyieldORTRaw @Station,@Prefix

set @total = 1
set @passed = 0
--set @ProdLine = 'Viper'

--declare @TestDate datetime
--declare @total int
--set @testdate = getdate()
--set @testdate=dateadd(day,-1,@ORT_Complete)
--select @testdate
select @total=count(*) from #tmpORTLog
where datediff(day,@ORT_Complete,ORT_Complete_Date) =0
--select @total

--select * from #tmpORTLog order by ORT_Complete_Date

select @passed=count(*) from #tmpORTLog
where datediff(day,@ORT_Complete,ORT_Complete_Date) =0
and Pass_Fail='P'

--set @ToORT = @total
--set @Cum = 'Y'

--select @TestDate As Build_Date,@Shift As Shift,@ProdLine As Product_Line,
--	 @Station As Test_Station,@Cum As Part_Of_Cum, @total As Qry_Tested_FP,
--	@ToORT As Qry_To_ORT,@passed As Qty_Pass_FP

--@Shift
-- @ProdLine
-- @Cum
-- @total
-- @ToORT
-- @passed



drop table #tmpORTLog
GO