SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_get_consumed_part]
@acsserial char(20),
@partnoname char(20) 
AS
set nocount on

declare @scanned char(20)


select @scanned = scanned_serial from asylog
inner join catalog on added_part_no = part_no_count
where acs_serial=@acsserial
and part_no_name=@partnoname


if @scanned is not null
begin
select @scanned
end
else
begin
select 'NOTFOUND'
end
GO