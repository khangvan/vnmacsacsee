SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TM_UpdateLasttimes]
 AS

set nocount on

update TM_LastLoadTimesPerSTation
set TM_LastDateTime =
maxtime from
(
select station, max(test_date_time) as maxtime
from tm_testlog
group by station
) x where x.station = TM_Station


insert into TM_LastLoadTimesPerStation
(
TM_Station, TM_LastDateTIme, TM_firstDateTime
)
select station, max(test_date_time), min(test_date_time)
from tm_testlog
where not exists ( select * from TM_LastLoadTimesPerStation
where TM_Station = station )
group by station
order by station
GO