SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_create_next_blackbird_mac_address] 
@range_min bigint,
@range_max bigint,
@next_mac bigint,
@description char(80)='',
@macgroup char(20)=''
 AS
set nocount on

if  exists ( select 1 from mac_range where ( @range_min >= range_min and @range_min <= range_max )
                 or (@range_max <= range_max and @range_max >= range_min)
                 or ( @range_min <= range_min and @range_max >= range_max)
               )
begin
select 'RANGES OVERLAP'
return
end

if @range_min > @range_max 
begin
select 'RANGEMIN GREATER THAN RANGEMAX'
return
end

if @next_mac < @range_min OR @next_mac > @range_max + 1
begin
select 'NEXTMAC OUT OF RANGE'
return
end

insert into mac_range
(
macgroup,
range_min,
range_max,
next_mac,
description
)
values
(
@macgroup,
@range_min,
@range_max,
@next_mac,
@description
)

select 'OK'

select @range_min, @range_max, @next_mac
GO