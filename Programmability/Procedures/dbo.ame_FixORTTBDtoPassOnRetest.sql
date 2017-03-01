SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FixORTTBDtoPassOnRetest]
 AS
set nocount on

delete from testlog
where len(rtrim(station)) < 1


update RawFruFailureLog set FLG_Critical = 0, FLG_Comments='Passed On Retest'
where FLG_FL_ID in
(
select y.FLG_FL_ID
from
(
select FLG_FL_ID,FLG_ACSSN, FLG_Station, FLG_FailureLogDate
from rawFruFailureLog where FLG_ORT='Y'
and FLG_Critical = 1
and
exists
(
select FLG_TL_ID from testlog
where testlog.test_date_time > dateadd(day,-7,getdate()) 
and testlog.acs_serial = FLG_ACSSN
and testlog.Station = FLG_Station
and Pass_fail='P'
and test_date_time > FLG_FailureLogDate
and Test_Date_Time < DateAdd(mi,5,FLG_FailureLogDate)
)
) y
)



update RawFruFailureLog
set FLG_RepairAction_ID = 1
where FLG_FL_ID in
(
select FLG_FL_ID from RawFruFailureLog 
where FLG_RepairAction_ID =19
and exists 
(
select TL_ID from testlog
where testlog.test_date_time > dateadd(day,-7,getdate())  
and substring(Station,1,len(Station) - 1) = substring(FLG_Station,1,len(FLG_Station) - 1 )
 and ACS_Serial=FLG_ACSSN 
and Pass_Fail = 'P'
and FLG_FailureLogDate <  Test_Date_Time
and DateAdd(hh,1,FLG_FailureLogDate) > Test_Date_Time
and FirstRun != 'O'
)
)
and FLG_ORT <> 'Y'


update RawFruFailureLog
set FLG_RepairAction_ID = 11
where FLG_FL_ID in
(
select FLG_FL_ID from RawFruFailureLog 
where FLG_RepairAction_ID =20
and exists 
(
select TL_ID from testlog
where testlog.test_date_time > dateadd(day,-7,getdate())  
and substring(Station,1,len(Station) - 1) = substring(FLG_Station,1,len(FLG_Station) - 1 )
 and ACS_Serial=FLG_ACSSN 
and Pass_Fail = 'P'
and FLG_FailureLogDate <  Test_Date_Time
and DateAdd(hh,1,FLG_FailureLogDate) > Test_Date_Time
and FirstRun != 'O'
)
)
and FLG_ORT <> 'Y'
GO