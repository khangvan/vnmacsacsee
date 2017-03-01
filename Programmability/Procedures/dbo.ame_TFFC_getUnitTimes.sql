SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_getUnitTimes]
	(
	@begintime datetime
	)
AS

set nocount on
declare @endtime  datetime 
set @endtime = @begintime + 1

select  
[ACSEEState].[dbo].loci.ProdOrder,
asylog.acs_serial,
min(action_date) as mindate, 
max(action_date) as maxdate
from asylog
left outer join tffc_serialnumbers on asylog.acs_serial = tffc_serialnumbers.TFFC_acsserial
inner join [ACSEEState].[dbo].loci on [ACSEEState].[dbo].loci.acs_serial = asylog.acs_serial
where action_date > @begintime and action_date < @endtime
group by  [ACSEEState].[dbo].loci.ProdOrder,asylog.acs_serial
GO