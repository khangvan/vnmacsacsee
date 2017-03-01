SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*

amevn_create_TestYieldReport '05/23/2016' ,'05/24/2016'
*/
       -- =============================================
       CREATE PROCEDURE [dbo].[amevn_create_TestYieldReport]
       
  (  @datetimeStart datetime ,
    @datetimeEnd datetime)
    AS
BEGIN

IF OBJECT_ID('tempdb..##tempPFYield') IS NOT NULL/*Then it exists*/   DROP TABLE ##tempPFYield


;WITH tbCleanData AS
( -- start CTE

SELECT Test_Date_Time,Convert(date, Test_Date_Time)  AS DateRun,
DATEPART(hour,Test_Date_Time) AS HourRun
,      ShiftRun=(CASE WHEN DATEPART(HOUR, Test_Date_Time) >= 6 AND
	DATEPART(HOUR, Test_Date_Time) < 14 THEN 1
                   WHEN DATEPART(HOUR, Test_Date_Time) >= 14 AND
	DATEPART(HOUR, Test_Date_Time) < 22 THEN 2
                   WHEN DATEPART(HOUR, Test_Date_Time) >= 22 OR
	DATEPART(HOUR, Test_Date_Time) < 6  THEN 3
                                         ELSE 0
END ),
Station
,      SAP_Model
	,      ACS_Serial
	
	,      CASE WHEN (
		sum(CASE WHEN Pass_Fail = 'F'
			AND FirstRun = 'Y' THEN 1
		                        ELSE 0 END) = 0
		)      THEN 1
	            ELSE 0 END AS FP
	,      CASE WHEN sum(CASE WHEN Pass_Fail = 'F'
			AND FirstRun = 'Y' THEN 1
		                        ELSE 0 END) = 0 THEN 0
	                                             ELSE (
		sum(CASE WHEN Pass_Fail = 'P' THEN 1
		                              ELSE 0 END) - CASE WHEN (
			sum(CASE WHEN Pass_Fail = 'F'
				AND FirstRun = 'Y' THEN 1
			                        ELSE 0 END) = 0
			)                                           THEN 1
		                                                 ELSE 0 END
		) END AS RTP
	,      (
	COUNT(DISTINCT ACS_Serial) - (
	CASE WHEN (
		sum(CASE WHEN Pass_Fail = 'F'
			AND FirstRun != 'N' THEN 1
		                         ELSE 0 END) = 0
		) THEN 1
	       ELSE 0
	END ) - (
	CASE WHEN sum(CASE WHEN Pass_Fail = 'F'
			AND FirstRun != 'N' THEN 1
		                         ELSE 0 END) = 0 THEN 0
	                                              ELSE (
		sum(CASE WHEN Pass_Fail = 'P' THEN 1
		                              ELSE 0 END) - CASE WHEN (
			sum(CASE WHEN Pass_Fail = 'F'
				AND FirstRun != 'N' THEN 1
			                         ELSE 0 END) = 0
			)                                           THEN 1
		                                                 ELSE 0 END
		)
	END )
	) AS F
	-- select *
	FROM [TestLog]
	WHERE dbo.TestLog.Test_Date_Time >= @datetimeStart AND dbo.TestLog.Test_Date_Time < @datetimeEnd
	GROUP BY
	 Test_Date_Time,
	 Station
	,        SAP_Model
	,        ACS_Serial
	

	) -- end CTE
	
	

	SELECT * INTO ##tempPFYield FROM tbCleanData tcd
	/*-------------------------------
	drop table ##tempPF
	select * from ##tempPFYield
	select * from testlog
	SELECT * FROM tbCleanData tcd
	*/-----------------------------

	IF OBJECT_ID('tempdb..##TempSumByYield') IS NOT NULL
     /*Then it exists*/
        DROP TABLE ##TempSumByYield

	;WITH tbSumbyShift AS (
	SELECT 
	 DateRun,
 HourRun,
     ShiftRun
	,tcd.Station 
	,      tcd.Sap_Model
	--,      COUNT(DISTINCT (tcd.ACS_Serial)) AS TotalSNTest
	--,      SUM(CASE WHEN FP > 0 THEN 1
	--                            ELSE 0 END) AS FirstPass
	--,      SUM(CASE WHEN RTP > 0 THEN 1
	--                             ELSE 0 END) AS Retestpass
	--,      SUM(CASE WHEN FP > 0 THEN 1
	--                            ELSE 0 END) + SUM(CASE WHEN RTP > 0 THEN 1
	--                                                                ELSE 0 END) AS TotalPass
	--,      SUM(CASE WHEN f > 0 THEN 1
	--                           ELSE 0 END) AS Fail
	,      convert(DECIMAL(6, 2), (
	CAST((
	SUM(CASE WHEN FP > 0 THEN 1
	                     ELSE 0 END)
	) AS decimal) / cast((count(DISTINCT ACS_serial)) AS decimal)
	) * 100) AS FirstPassYield
	--,      convert(DECIMAL(6, 2), (
	--CAST((
	--SUM(CASE WHEN FP > 0 THEN 1
	--                     ELSE 0 END) + SUM(CASE WHEN RTP > 0 THEN 1
	--                                                         ELSE 0 END)
	--) AS FLOAT) / cast((count(DISTINCT ACS_serial)) AS FLOAT)
	--) * 100) AS RealYield
	FROM tempPFYield tcd
	GROUP BY tcd.DateRun,tcd.ShiftRun, tcd.HourRun,tcd.Station 
	,      tcd.Sap_Model
	--ORDER BY tcd.Station, tcd.SAP_Model
	)
	SELECT * INTO ##TempSumByYield FROM tbSumbyShift

	-- select * from ##TempSumByYield
	
	;WITH  tbSumDay
	AS (select daterun,station, sap_model, HourRun, FirstPassYield from ##TempSumByYield tsbsByShift)
	SELECT * FROM tbSumDay tsd
pivot (sum  (FirstPassYield) for HourRun in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])) as TotalPassPerDay
ORDER BY daterun

;WITH  tbSumShift
	AS (select daterun,station, sap_model, ShiftRun, FirstPassYield from ##TempSumByYield tsbsByShift)
	SELECT * FROM tbSumShift tsf
pivot (sum  (FirstPassYield) for ShiftRun in ([1],[2],[3])) as TotalPassPerShift
ORDER BY daterun


	--CREATE TABLE ##tempHour
	--(DateRun datetime,
	--HourRUN int,
	--ShiftRun int,
	--Station varchar(50),
	--Model varchar(30),
	--PassOut int
	--)

	--SELECT * FROM ##tempHour th
	end
GO