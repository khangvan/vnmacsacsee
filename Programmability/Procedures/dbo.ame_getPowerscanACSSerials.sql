SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getPowerscanACSSerials]
@pscserial char(20)
 AS
set nocount on
select acs_serial, station_name, part_no_name, action_date from asylog 
inner join stations on station = station_count 
inner join catalog on added_part_no = part_no_count
where scanned_serial =
/* in
(
select psc_serial from assemblies where acs_serial =
*/
@pscserial


/*)   */
order by action_date
GO