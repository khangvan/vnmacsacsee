SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


CREATE proc [dbo].[sp_getyieldORTRaw]
	@Station varchar(30),
	@Prefix char(2)
as

CREATE TABLE #tmpORTLog2 (
	[ACS_Serial] [char] (20) NOT NULL ,
	ORT_Complete_Date datetime NULL ,
	Test_Date_Time datetime NULL ,
	Test_Station char(30) NULL,
	[Pass_Fail] [char] (3) NULL
)

set nocount on

-- Replace this which what I have in getYieldORT
--Old:
--insert #tmpORTLog2
--exec sp_getyieldORT
--**********************
--New:
insert #tmpORTLog2
	select subtestlog.ACS_Serial,
		substring(subTestlog.Test_ID,len(ltrim(subtestlog.Station))+1,25) 
	As ORT_Complete_Date,testlog.Test_Date_Time,testlog.Station,
		testlog.Pass_Fail
	from subtestlog 
	inner join testlog on subtestlog.ACS_Serial = testlog.ACS_Serial
	where subtestlog.subtest_name='EXITORT' and 
		datediff(mi,Test_Date_Time,convert(datetime,substring(subTestlog.Test_ID,len(ltrim(subtestlog.Station))+1,25)))<0
		and substring(testlog.Station,1,5)<>'ACSEE'
	order by subtestlog.ACS_Serial

--		Test_Date_Time>substring(subTestlog.Test_ID,len(ltrim(subtestlog.Station))+1,25)



--**********************

SELECT
	ACS_Serial,
	ORT_Complete_Date,
	Test_Date_Time,
	Test_Station,
	Pass_Fail
FROM
	#tmpORTLog2
WHERE
	(
	Test_Date_Time IN
		(
		SELECT TOP 100 percent
			MIN(Test_Date_Time) AS Test_Date_Time
		FROM
			#tmpORTLog2
		WHERE
			(Test_Station =Ltrim(@Station))
			and (substring(ACS_Serial,1,2)=@Prefix)
			--and (Test_Date_Time>'2002-05-01 23:37:03.000')
		GROUP BY
			ACS_Serial
		ORDER BY
			ACS_Serial
		)
	)
order by ACS_Serial

drop table #tmpORTLog2
GO