SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_GetLatestBackFlush]
 AS
set nocount on

declare @candidatePOs table (
	[FFC_BackFlush_PO] [nchar] (50)  ,
	[FFC_BackFlush_Item] [int],
             [FFC_BackFlush_TotalQty] [int] NULL
)


declare  @myFlush table (
	[FFC_BackFlush_ID] [int] NOT NULL ,
	[FFC_BackFlush_PO] [nchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FFC_BackFlush_POItem] [int] NULL ,
	[FFC_BackFlush_Material] [nchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FFC_BackFlush_Qty] [int] NULL ,
	[FFC_BackFlush_SerialNo] [nchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FFC_BackFlush_Date] [datetime] NULL 
)

declare @lastid int
declare @newlastid int
select @lastid = FFC_LastBackFlush_ID from FFC_BackFlush_TrackLast


declare @CandidatePO char(50)
declare @CandidateItem int
declare @TotalQty int
declare @TotalCount int

insert into @candidatePOs
(
FFC_BackFlush_PO,
FFC_BackFlush_Item,
FFC_BackFlush_TotalQty
)
select distinct FFC_BackFlush_PO,FFC_BackFlush_POItem,FFC_SO_Qty
from FFC_Backflush_Current
inner join FFC_SalesOrders on FFC_BackFlush_PO = FFC_SO_PurchaseOrder and FFC_BackFlush_POItem = FFC_SO_PurchaseItem
where FFC_Backflush_Locked = 0



declare cur_checkPOs CURSOR FOR
select FFC_BackFlush_PO, FFC_BackFLush_Item,FFC_BackFlush_TotalQty from @candidatePOs

open cur_checkPOs
FETCH NEXT FROM cur_checkPOs INTO @CandidatePO,  @CandidateItem, @TotalQty
while @@FETCH_STATUS = 0
begin
   select @TotalCount = count(*) from FFC_BackFlush_Current where FFC_BackFlush_PO = @CandidatePO and FFC_BackFlush_POItem = @CandidateItem
print @CandidatePO
print @CandidateItem

print @TotalCount
print @TotalQty
   if (@TotalCount >= @TotalQty )
   begin
      update FFC_BackFlush_Current set FFC_BackFlush_Locked = 1, FFC_BackFlush_LockDate = getdate() where FFC_BackFlush_PO = @CandidatePO and FFC_BackFlush_POItem=@CandidateItem
                                             
	insert into @myFlush
	(
		FFC_BackFlush_ID, 
		FFC_BackFlush_PO, 
		FFC_BackFlush_POItem, 
		FFC_BackFlush_Material, 
		FFC_BackFlush_Qty, 
		FFC_BackFlush_SerialNo, 
		FFC_BackFlush_Date
	)
	select FFC_BackFlush_ID, 
		FFC_BackFlush_PO, 
		FFC_BackFlush_POItem, 
		FFC_BackFlush_Material, 
		FFC_BackFlush_Qty, 
		FFC_BackFlush_SerialNo, 
		FFC_BackFlush_Date
		from FFC_BackFlush_Current where FFC_BackFlush_PO = @CandidatePO and FFC_BackFlush_POItem= @CandidateItem
   end
   
   FETCH NEXT FROM cur_checkPOs INTO @CandidatePO, @CandidateItem, @TotalQty
end
close cur_checkPOs
deallocate cur_checkPOs 



delete from FFC_BackFlush_Current
where FFC_BackFlush_PO in
(select FFC_BackFlush_PO from FFC_BackFLush_Current where not exists (
select FFC_SO_SalesOrder from SalesOrders where FFC_SO_PurchaseOrder = FFC_BackFlush_PO
))
and FFC_BackFlush_Locked = 0
/*
insert into @myFlush
(
FFC_BackFlush_ID, 
FFC_BackFlush_PO, 
FFC_BackFlush_POItem, 
FFC_BackFlush_Material, 
FFC_BackFlush_Qty, 
FFC_BackFlush_SerialNo, 
FFC_BackFlush_Date
)
select FFC_BackFlush_ID, 
FFC_BackFlush_PO, 
FFC_BackFlush_POItem, 
FFC_BackFlush_Material, 
FFC_BackFlush_Qty, 
FFC_BackFlush_SerialNo, 
FFC_BackFlush_Date
from FFC_BackFlush_Current where FFC_BackFlush_ID > @lastid
*/

/*select @newlastid = max(FFC_BackFlush_ID) from @myFlush

update FFC_BackFlush_TrackLast set FFC_LastBackFlush_ID = @newlastid
*/

select
FFC_BackFlush_PO, 
FFC_BackFlush_POItem, 
FFC_BackFlush_Material, 
FFC_BackFlush_Qty, 
FFC_BackFlush_SerialNo
from @myFlush


update ffc_Backflush_current set ffc_BackFlush_CountQty =
x.totalqty
from
(
select ffc_backflush_PO, ffc_Backflush_POItem, count(*) as totalqty
from ffc_backflush_current
group by  ffc_backflush_PO, ffc_Backflush_POItem
) x
where x.ffc_backflush_PO = ffc_backflush_current.ffc_backflush_PO and
x.ffc_backflush_POItem = ffc_BackFlush_Current.ffc_backflush_POItem



insert into FFC_BackFlush_SendBack
(
FFC_BackFlush_PO,
 FFC_BackFlush_POItem, 
FFC_BackFlush_Material, 
FFC_BackFlush_Qty, 
FFC_BackFlush_SerialNo,
 FFC_BackFlush_Date, 
FFC_BackFlush_Locked, 
FFC_BackFlush_LockDate,
 FFC_BackFlush_SentAssembly, 
FFC_BackFlush_SentTestLog,
 FFC_BackFLush_SentSubtestLog
)
select
FFC_BackFlush_PO, 
FFC_BackFlush_POItem, 
FFC_BackFlush_Material, 
FFC_BackFlush_Qty, 
FFC_BackFlush_SerialNo,
FFC_BackFlush_Date,
1,
getdate(),
0,
0,
0
from @myFlush


exec master..xp_cmdshell 'DTSRun /S"(local)"  /N"ReportDailyAssigns" /E '
GO