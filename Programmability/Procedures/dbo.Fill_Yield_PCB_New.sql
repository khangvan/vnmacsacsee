SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

create proc [dbo].[Fill_Yield_PCB_New]
as
declare @Station char(30)
declare @SAPModel char(30)
declare @ProductLine char(20)
declare @QtyTestedFP int
declare @QtyPassedFP int
declare @DateTested datetime
declare @TempDate datetime
declare @Description char(50)
set @DateTested = dateadd(day,-1,getdate())
set @TempDate = convert(datetime,
	convert(char(2),datepart(m,@DateTested))+'/'+convert(char(2),datepart(d,@DateTested))+'/'
	+convert(char(4),datepart(yyyy,@DateTested)))
set @DateTested = @TempDate

--Define the two cursors
declare PCBCursor Scroll Cursor for
   select Station_Name,SAP_Model_Name from products left join stations
	on products.status=stations.status
	where products.status='A' and substring(SAP_Model_Name,1,2)='3-' and 
	   Perform_Test='Y' and stations.status='A' and ProductGroup_Mask = 2


open PCBCursor

--Do the first one...
fetch next from PCBCursor
	into @Station,@SAPModel

select @Description = Description from BOM where SAP_Model=@SAPModel and Part_Number='INFO'
exec PCB @Station,@SAPModel,@DateTested,
	@ProductLine OUT, @QtyTestedFP OUT, @QtyPassedFP OUT
if @QtyTestedFP>0
begin
   insert Yield_PCB
   values(@DateTested,@Station,@SAPModel,@ProductLine,@QtyTestedFP,@QtyPassedFP,@Description)
end
--Now do the rest...
while @@FETCH_STATUS=0
   BEGIN
	fetch next from PCBCursor
		into @Station,@SAPModel
	select @Description = Description from BOM where SAP_Model=@SAPModel and Part_Number='INFO'
	exec PCB @Station,@SAPModel,@DateTested,
		@ProductLine OUT, @QtyTestedFP OUT, @QtyPassedFP OUT
	if @QtyTestedFP>0
	   begin
   		insert Yield_PCB
   		   values(@DateTested,@Station,@SAPModel,@ProductLine,@QtyTestedFP,
			@QtyPassedFP,@Description)
	   end
   end

	

GO