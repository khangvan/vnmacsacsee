SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TMRawTECInsert]
@SerialCode char(20), 
@Model char(20), 
@Station char(20), 
@Date datetime, 
@Time datetime, 
@Details char(80), 
@Esito char(10), 
@ValueAcquired char(80), 
@Extra1 char(80), 
@Extra2 char(80)
 AS
set nocount on




declare @timeofrecordbeingadded datetime
declare @lastmaxdatetimeforstation datetime
/*

insert into TM_LastLoadTimesPerStation
(
TM_Station, TM_LastDateTIme, TM_firstDateTime
)
select station, max(test_date_time), min(test_date_time)
from tm_testlog
group by station
order by station




select tec_date, tec_time,
dateadd(ss,datepart(ss,tec_time),
dateadd(mi,datepart(mi,tec_time),
DateAdd(hh,datepart(hh,tec_time),tec_date)))

from tm_rawTECData
where tecrec_id < 1000


select TM_LastDateTime from tm_lastloadtimesperstation
where TM_Station = rtrim('AHORNAKOVA-XP      ') + 'i1'

*/


set @timeofrecordbeingadded =
dateadd(ss,datepart(ss,@time),
dateadd(mi,datepart(mi,@time),
DateAdd(hh,datepart(hh,@time),@date)))


print 'timeofrecordbeingadded'
print @timeofrecordbeingadded

if exists (select    TM_LastDateTime from tm_lastloadtimesperstation
where TM_Station = rtrim(@station) + '1')
begin
print 'found station'
select   @lastmaxdatetimeforstation = TM_LastDateTime from tm_lastloadtimesperstation
where TM_Station = rtrim(@station) + '1'
end
else
begin
print 'did not find station'
set @lastmaxdatetimeforstation = '1/1/2009'
end



if  @timeofrecordbeingadded > @lastmaxdatetimeforstation
begin
insert into TM_RawTECData
(
TEC_SerialCode, 
TEC_Model, 
TEC_Station, 
TEC_Date, 
TEC_Time, 
TEC_Details, 
TEC_Esito, 
TEC_ValueAcquired, 
TEC_Extra1, 
TEC_Extra2
)
values
(
@SerialCode, 
@Model , 
@Station , 
@Date, 
@Time , 
@Details , 
@Esito , 
@ValueAcquired , 
@Extra1 , 
@Extra2 
)

select 'OK'
end
else
begin
select 'NO'
end
GO