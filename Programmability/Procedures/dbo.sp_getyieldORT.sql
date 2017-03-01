SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


CREATE proc [dbo].[sp_getyieldORT]
As
select subtestlog.ACS_Serial,
substring(subTestlog.Test_ID,len(ltrim(subtestlog.Station))+1,25) 
As ORT_Complete_Date,testlog.Test_Date_Time,testlog.Station,
testlog.Pass_Fail
from subtestlog 
inner join testlog on subtestlog.ACS_Serial = testlog.ACS_Serial
where subtestlog.subtest_name='EXITORT' and 
Test_Date_Time>substring(subTestlog.Test_ID,len(ltrim(subtestlog.Station))+1,25)
and substring(testlog.Station,1,5)<>'ACSEE'
order by subtestlog.ACS_Serial




GO