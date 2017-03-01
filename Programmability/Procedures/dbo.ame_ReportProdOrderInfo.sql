SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_ReportProdOrderInfo]
@prodorder char(20)
 AS

set nocount on

declare @realprodorder char(20)
declare @minid int

declare @totalcount int
declare @startedcount int
declare @finishedcount int

declare @cdate datetime
declare @tendaydate datetime


set @realprodorder = rtrim(@prodorder)

while len( @realprodorder) < 12
begin
set @realprodorder = '0' + @realprodorder
end


select @minid = min(tffc_id) from tffc_serialnumbers where tffc_prodorder = @realprodorder
set @minid = @minid - 1
--print '[' + @realprodorder + ']'


set @cdate = getdate()
set @tendaydate =dateadd(day, -7, @cdate)
print @tendaydate

select @totalcount = count(*) from tffc_serialnumbers where tffc_prodorder = @realprodorder
print @totalcount

/*
select @startedcount = count(*) from [ACSEEState].dbo.locilog where 
last_event_date > @tendaydate
and
prodorder=@realprodorder
and station like '%START%'
*/

if exists (
select row_id from 
( select * from
 [ACSEEState].dbo.locilog where 
last_event_date > @tendaydate
and station like '%START%'
) y
where y.prodorder=@realprodorder
)
begin
select @startedcount = count(*) from 
(
select * from  [ACSEEState].dbo.locilog where 
last_event_date > @tendaydate
and station like '%START%'
)x
where
x.prodorder=@realprodorder
end
else
begin
set @startedcount = 0
end
print @startedcount

select @totalcount as totalcount, @startedcount as startedcount,  tffc_id - @minid as rowid, tffc_prodorder, tffc_serialnumber,tffc_reservedby, tffc_material, tffc_description,
tffc_ACSSerial,tffc_period, tffc_refreshdate from tffc_serialnumbers
where tffc_prodorder=@realprodorder
order by tffc_serialnumber
GO