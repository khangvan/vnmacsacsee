SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_RemoveBadDuplicates]
 AS
set nocount on
update tffc_serialnumbers set tffc_reserved=0, tffc_consumed=0, tffc_reservedby=''
where tffc_id in
(
select tffc_id from tffc_serialnumbers
inner join
(
select acs_serial, psc_serial from [ACSEEState].[dbo].loci
where acs_serial in
(
select tffc_reservedby from
(
select tffc_reservedby, count(*) as num from tffc_serialnumbers
where len(rtrim(tffc_reservedby)) > 0
group by tffc_reservedby
having count(*) > 1
) x
)
and len(rtrim(psc_serial)) > 0 
) y on y.acs_serial = tffc_reservedby and y.psc_serial !=tffc_serialnumber
)
GO