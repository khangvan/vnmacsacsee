SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO







/*

*/

CREATE PROCEDURE [dbo].[amevn_Report_Test_client_statistic2]
	-- Add the parameters for the stored procedure here
	--@boolrealtime bit --	-- @bool = 1 => autoget dateime
	( @datetimego Datetime 
	 ,@iTime24h int 
	 ,@inext int
		,@Station varchar(40)
            )
             
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;
	-- input declare
	declare @from_date datetime
	declare @to_date datetime
	declare @from_hour int
	declare @to_hour int

	DECLARE @QT1 int
	DECLARE @QT2 int
	DECLARE @QT3 int
	DECLARE @QT4 int
	

	DECLARE @Mode int
	DECLARE @Average int
	DECLARE @Median int
	DECLARE @min int
	DECLARE @Max int
	DECLARE @CountTest int

	DECLARE @stationname varchar(30)
	SET @stationname =@Station
	

	BEGIN
		set @from_hour =@iTime24h
		set @to_hour =@iTime24h+@inext
    	SET @from_date = DAteadd(minute,0,DATEADD(HOUR,@from_hour,(DATEADD(DAY, 0, @datetimego))))
		SET @to_date =   DAteadd(second,0,DAteadd(minute,0,DATEADD(HOUR,@to_hour,(DATEADD(DAY, 0, @datetimego)))))
    END


---phan 2
--USE [master] GO
--EXEC MASTER.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'SQL16NODEB\SQL2014', @locallogin = NULL , @useself = N'False', @rmtuser = N'sa', @rmtpassword = N'sa'
--GO
--EXEC VNCapacityControl_SPUpdateAll

IF OBJECT_ID('tempdb..##TSTDATARAW') IS NOT NULL
/*Then it exists*/
   DROP TABLE ##TSTDATARAW
  IF OBJECT_ID('tempdb..##TSTDATA') IS NOT NULL
/*Then it exists*/
   DROP TABLE ##TSTDATA
--Create Table ##TSTDATA
--([RowNum] INT,[TestDate] DATETIME,[Station] varchar(60),[Task] varchar(60),[PF] varchar(2),[EventDate] datetime,[StartTime] datetime,[EndTime] datetime,[DiffSec] int, [DiffMin] int, [TAKT] int);
  IF OBJECT_ID('tempdb..##Result') IS NOT NULL
/*Then it exists*/
   DROP TABLE ##Result

;WITH 
CTE
AS
(
	SELECT ROW_NUMBER()OVER(/*PARTITION BY tl.Station*/ ORDER BY tl.Station,CONVERT(date,Test_Date_Time) , TL_ID )As RowNum
	,      tl.*, VNCAPACITYCONTROL.TargetHRS
	FROM dbo.TestLog tl, VNCapacityControl
	WHERE (Test_Date_Time BETWEEN @from_date AND @to_date)
	--WHERE (Test_Date_Time BETWEEN '04/05/2016 06:00' AND '04/05/2016 10:00')
		AND Station = @Station
	      AND [VNCapacityControl].productgroup = tl.SAP_Model
)
--INSERT INTO  ##TSTDATA ([RowNum],[TestDate],[Station],[Task],[PF],[EventDate],[StartTime],[EndTime],[DiffSec],[DiffMin], [TAKT])
SELECT CTE.RowNum
--,      CONVERT(date,Test_Date_Time) AS TestDate
,      CTE.Station
,	Task=RTRIM(SAP_Model)+'_'+RTRIM(ACS_Serial) +'_'+FirstRun+'_'+Pass_Fail+'C'+cast(ISNULL( DATEDIFF(s,Test_Date_Time,(SELECT  c2.Test_Date_Time FROM CTE c2 WHERE 	c2.RowNum=CTE.RowNum+1)),0) AS varchar(10))
,Pass_Fail AS PF
,      EventDate= CONVERT(date,Test_Date_Time)
,      StartTime=CONVERT(time,Test_Date_Time)
,      EndTime= ISNULL(CONVERT(time,DATEADD(second,CAST((DATEDIFF(s,Test_Date_Time,(SELECT c2.Test_Date_Time
FROM CTE c2
WHERE c2.RowNum=CTE.RowNum+1))) as float),Test_Date_Time)) ,(CONVERT(time,Test_Date_Time)))
,      DiffSec=ISNULL( DATEDIFF(s,Test_Date_Time,(SELECT c2.Test_Date_Time
FROM CTE c2
WHERE c2.RowNum=CTE.RowNum+1)),0)
,      DiffMin=ISNULL(ROUND(CAST((DATEDIFF(s,Test_Date_Time,(SELECT c2.Test_Date_Time
FROM CTE c2
WHERE c2.RowNum=CTE.RowNum+1))) as float)/60,2),0)
, TaktimeSEC = ISNULL(ROUND((60*60/cast(CTE.TargetHRS as float)),2),0)
into ##TSTDATARAW
FROM CTE -- , VNCapacityControl Ccvn
--ORDER BY CTE.Station, CTE.TL_ID


--WHERE  [VNCapacityControl].ProductGroup = CTE.SAP_Model
--SELECT * FROM [10.84.10.67\SIPLACE_2008R2EX].[PTR].[dbo].[CapacityControl]

-- pass data
SELECT t.RowNum, t.Station, t.Task, t.EventDate,t.StartTime
, t.DiffSec, t.DiffMin,  t.TaktimeSEC
INTO ##TSTDATA FROM ##TSTDATARAW  t
WHERE PF ='P'

SELECT @CountTest =COUNT(*) FROM ##TSTDATA 


--khang add 21 Apr 2016
--DROP TABLE ##TSTDATA
--SELECT * FROM ##TSTDATA t


;WITH CTEPV as
(select quartile,max(DiffSec ) as Value
from    (select DiffSec, ntile(4) over (order by DiffSec ) as [quartile]
         from   ##TSTDATA) i
--where quartile = 2
group by quartile)
SELECT  @QT1= [1] ,@QT2= [2], @QT3=[3] , @QT4=[4]  FROM ctepv
PIVOT (
SUM(value) FOR quartile IN ([1],[2],[3],[4] )

) as P



--Min
--select  @min=max(DiffSec ) --as [my_column], quartile
--from    (select DiffSec, ntile(4) over (order by DiffSec ) as [quartile]
--         from   ##TSTDATA) i
--where quartile = 1
--group by quartile
SELECT @Min=min(DiffSec ) from   ##TSTDATA

--max
--select  @Max=max(DiffSec ) --as [my_column], quartile
--from    (select DiffSec, ntile(4) over (order by DiffSec ) as [quartile]
--         from   ##TSTDATA) i
--where quartile = 4
--group by quartile

SELECT @Max=max(DiffSec ) from   ##TSTDATA


--
SELECT @Median=
(
 (SELECT MAX(DiffSec) FROM
   (SELECT TOP 50 PERCENT DiffSec FROM ##TSTDATA ORDER BY DiffSec) AS BottomHalf)
 +
 (SELECT MIN(DiffSec) FROM
   (SELECT TOP 50 PERCENT DiffSec FROM ##TSTDATA ORDER BY DiffSec DESC) AS TopHalf)
) / 2 
--AS Median

select @Average=AVG(DiffSec)  FROM ##TSTDATA  
--mode
SELECT TOP 1 @Mode
=  DiffSec 
FROM   ##TSTDATA
WHERE  DiffSec IS Not NULL
GROUP  BY DiffSec
ORDER  BY COUNT(*) DESC


SELECT @stationname AS Station, 'ForPass' AS PFGroup, @CountTest AS CountTST,
@QT1 AS Quartile1,@QT2 AS Quartile2, @QT3 AS Quartile3,@QT4 AS Quartile4
,@Median AS Median
,      @Mode AS Mode
,      @min AS Min
,      @Max AS Max
,      @Average AS Average
,cast( @Average/60 as decimal(5,2)) AS AverageinMin

--,      @from_date
--,      @to_date
,      60*60/@Median AS SuggestTargetHr
,      420*60/@Median AS SuggestTargetShift
INTO ##Result











----- Do for FAIL
 IF OBJECT_ID('tempdb..##TSTDATAF') IS NOT NULL
/*Then it exists*/
   DROP TABLE ##TSTDATAF

-- Fail  data
SELECT t.RowNum, t.Station, t.Task, t.EventDate,t.StartTime
, t.DiffSec, t.DiffMin,  t.TaktimeSEC
INTO ##TSTDATAF FROM ##TSTDATARAW  t
WHERE PF ='F'

SELECT @CountTest =COUNT(*) FROM ##TSTDATAF 

--khang add 21 Apr 2016
--DROP TABLE ##TSTDATAF
--SELECT * FROM ##TSTDATAF t


;WITH CTEPV as
(select quartile,max(DiffSec ) as Value
from    (select DiffSec, ntile(4) over (order by DiffSec ) as [quartile]
         from   ##TSTDATAF) i
--where quartile = 2
group by quartile)
SELECT  @QT1= [1] ,@QT2= [2], @QT3=[3] , @QT4=[4]  FROM ctepv
PIVOT (
SUM(value) FOR quartile IN ([1],[2],[3],[4] )

) as F



--Min
--select  @min=max(DiffSec ) --as [my_column], quartile
--from    (select DiffSec, ntile(4) over (order by DiffSec ) as [quartile]
--         from   ##TSTDATAF) i
--where quartile = 1
--group by quartile
SELECT @min=min(DiffSec) from   ##TSTDATAF
--max
--select  @Max=max(DiffSec ) --as [my_column], quartile
--from    (select DiffSec, ntile(4) over (order by DiffSec ) as [quartile]
--         from   ##TSTDATAF) i
--where quartile = 4
--group by quartile
SELECT @max=max(DiffSec) from   ##TSTDATAF


--
SELECT @Median=
(
 (SELECT MAX(DiffSec) FROM
   (SELECT TOP 50 PERCENT DiffSec FROM ##TSTDATAF ORDER BY DiffSec) AS BottomHalf)
 +
 (SELECT MIN(DiffSec) FROM
   (SELECT TOP 50 PERCENT DiffSec FROM ##TSTDATAF ORDER BY DiffSec DESC) AS TopHalf)
) / 2 
--AS Median

select @Average=AVG(DiffSec)  FROM ##TSTDATAF  
--mode
SELECT TOP 1 @Mode
=  DiffSec 
FROM   ##TSTDATAF
WHERE  DiffSec IS Not NULL
GROUP  BY DiffSec
ORDER  BY COUNT(*) DESC

INSERT INTO  ##Result (##result.Station, PFGroup,##Result.CountTST, Quartile1, Quartile2, Quartile3, Quartile4, Median, Mode, Min, Max, Average,AverageinMin, SuggestTargetHr, SuggestTargetShift)
SELECT @stationname AS Station, 'ForFail' AS PFGroup,@CountTest,
@QT1 AS Quartile1,@QT2 AS Quartile2, @QT3 AS Quartile3,@QT4 AS Quartile4
,@Median AS Median
,      @Mode AS Mode
,      @min AS Min
,      @Max AS Max
,      @Average AS Average
,cast( @Average/60 as decimal(5,2)) AS AverageinMin
--,      @from_date
--,      @to_date
,      60*60/@Median AS SuggestTargetHr
,      420*60/@Median AS SuggestTargetShift

----- Do for FAIL




SELECT * FROM ##Result r

END


/*
exec [amevn_Report_Test_client_statistic] '03/31/2016' , '7' ,1,'COBALTOPERF2'

[amevn_Report_Test_client_statistic2] '05/24/2016', 14,3, 'MOSCONFIG6'


*/
GO