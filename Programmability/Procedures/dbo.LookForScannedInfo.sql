SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[LookForScannedInfo]
@AddedPart char (20)=NULL,
@ProdOrder char (20)=NULL
as

set nocount on

if ((@AddedPart is null) or (@ProdOrder is null))
begin
       select 'NULL Argument'
       return
end

if ((rtrim(@AddedPart)='') or (rtrim(@ProdOrder)=''))
begin
       select 'Empty Argument'
       return
end

declare @temp int
set @temp=0

select @temp=part_no_count
from dbo.Catalog
where part_no_name=rtrim(@AddedPart)

if (@temp<=0)
begin
       select 'Missing Controlled Part'
       return
end

select dbo.TFFC_SerialNumbers.TFFC_Material as TopModel,
              dbo.TFFC_SerialNumbers.TFFC_SerialNumber as TopModelSerial,
              dbo.asylog.scanned_serial as ScannedInInfo,
              dbo.TFFC_SerialNumbers.TFFC_ACSSErial as Traveller

from dbo.asylog inner join dbo.TFFC_SerialNumbers 
       on dbo.asylog.ACS_Serial = dbo.TFFC_SerialNumbers.TFFC_ACSSErial

where (dbo.TFFC_SerialNumbers.TFFC_ProdOrder = rtrim(@ProdOrder) and dbo.asylog.added_part_no = @temp)
order by 1,2

return
GO