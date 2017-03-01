SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


CREATE proc [dbo].[PCB]
-- Define input parameters
	@Station varchar(30),
	@SAPModel char(30),
	@TestDate datetime,
	@ProdLine char(20) OUTPUT,
	@total int OUTPUT,
	@passed int OUTPUT

-- Define code
AS


CREATE TABLE #tmpTestLog (
	[ACS_Serial] [char] (20) NOT NULL ,
	[SAP_Model] [char] (20) NULL ,
	[Station] [char] (20) NULL ,
	[Test_ID] [char] (50) NULL ,
	[Pass_Fail] [char] (3) NULL ,
	[FirstRun] [char] (2) NULL ,
	[Test_Date_Time] [datetime] NULL ,
	[ACSEEMode] [int] NULL 
)

set nocount on

insert #tmpTestLog
exec sp_getyieldPCB @Station,@SAPModel

set @total = 1
set @passed = 0
set @ProdLine = substring(upper(@Station),1,5)


select @total=count(*) from #tmpTestLog
where datediff(day,@TestDate,Test_Date_Time) =0

select @passed=count(*) from #tmpTestLog
where datediff(day,@TestDate,Test_Date_Time) =0
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



drop table #tmpTestLog



GO