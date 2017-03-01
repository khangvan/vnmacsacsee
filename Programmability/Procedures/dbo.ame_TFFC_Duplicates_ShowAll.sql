SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_Duplicates_ShowAll]
 AS
set nocount on
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
GO