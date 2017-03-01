SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
create proc [dbo].[ame_remove_part_control]
-- Define input parameters
@pname 		char(20) = NULL, 
@sname	char(20) = NULL
AS
set nocount on

declare @plid int

select @plid = pl_id from partlist
inner join catalog on part_no = part_no_count
inner join stations on station = station_count
where rtrim(part_no_name)= rtrim(@pname)          
and rtrim(station_name)=rtrim(@sname)


if @plid is not null
begin
delete from partlist where pl_id = @plid
return 1
end

return 0
GO