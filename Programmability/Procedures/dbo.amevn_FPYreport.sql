SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		/*Author*/
-- Create date: /*Create Date*/
-- Description:	/*Description*/
-- =============================================
CREATE PROCEDURE [dbo].[amevn_FPYreport]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


/*
quan trong : tl.acs_serial, tl.sap_model, tl.station
3 truong nay khi thay doi phai dong bộ
*/
select tl.acs_serial, tl.sap_model, tl.station, tl.cnt --count
,fp.pass_fail as firstResult, fp.test_date_time as firstDate
,lt.pass_fail as lastResult, lt.test_date_time as lastDate
, DATEDIFF(hh,fp.test_date_time, lt.test_date_time) AS ReworkTimeHours
/*neverpass*/
,FinalResult= CASE 
WHEN (/*(DATEDIFF(hh,fp.test_date_time, lt.test_date_time)>8) AND*/  (lt.pass_fail='F') ) THEN 'NVP'
WHEN ((DATEDIFF(hh,fp.test_date_time, lt.test_date_time)<8) /*and (fp.pass_fail='P')*/ AND  (lt.pass_fail='P') ) THEN 'FP'
WHEN (DATEDIFF(hh,fp.test_date_time, lt.test_date_time)>=8) /*AND  (fp.pass_fail='P')*/ and lt.pass_fail ='P'  THEN 'RTP'

ELSE 'NA' end
 from (
select acs_serial, sap_model, station, count(acs_serial) as cnt --count here
from testlog 
WHERE   ltrim(RTRIM(acs_serial)) LIKE '[a-zA-Z0-9]%'
AND dbo.testlog.Test_Date_Time >='10/27/2016'
AND dbo.testlog.SAP_Model ='740175800'
group by acs_serial, sap_model, station
) tl
left join 
(

select  acs_serial, sap_model, station, pass_fail, test_date_time,
row_number() over (partition by acs_serial, sap_model, station order by test_date_time asc) rn1
from testlog
) fp
on fp.acs_serial = tl.acs_serial
and fp.sap_model= tl.sap_model
and fp.station = tl.station
and rn1=1
-- last test

left join 
(

select  acs_serial, sap_model, station, pass_fail, test_date_time,
row_number() over (partition by acs_serial, sap_model, station order by test_date_time desc) rn2
from testlog
) lt -- last test
on lt.acs_serial = tl.acs_serial
and lt.sap_model= tl.sap_model
and lt.station = tl.station
and rn2=1


END
GO