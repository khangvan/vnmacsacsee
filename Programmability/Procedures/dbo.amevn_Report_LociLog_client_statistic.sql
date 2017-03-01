SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO








CREATE PROCEDURE [dbo].[amevn_Report_LociLog_client_statistic]
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
	DECLARE @TargetSetup int

	DECLARE @Mode int
	DECLARE @Average int
	DECLARE @Median int
	DECLARE @min int
	DECLARE @Max int
	

	BEGIN
		set @from_hour =@iTime24h
		set @to_hour =@iTime24h+@inext
    	SET @from_date = DAteadd(minute,0,DATEADD(HOUR,@from_hour,(DATEADD(DAY, 0, @datetimego))))
		SET @to_date =   DAteadd(second,0,DAteadd(minute,0,DATEADD(HOUR,@to_hour,(DATEADD(DAY, 0, @datetimego)))))
    END

--;WITH 
--CTE
--AS
--(
--	SELECT ROW_NUMBER()OVER(/*PARTITION BY tl.Station*/ ORDER BY tl.Station,CONVERT(date,Test_Date_Time) , TL_ID )As RowNum
--	,      *
--	FROM dbo.TestLog tl
--	WHERE (Test_Date_Time BETWEEN @from_date AND @to_date)
--		--AND Station = @Station
--		AND Station like 'COBALTOPERF%'
--)

--SELECT CTE.RowNum
--,      CONVERT(date,Test_Date_Time) AS TestDate
--,      CTE.Station
--,	Task=RTRIM(SAP_Model)+'_'+RTRIM(ACS_Serial) +'_'+FirstRun+'_'+Pass_Fail+'C'+cast(ISNULL( DATEDIFF(s,Test_Date_Time,(SELECT  c2.Test_Date_Time FROM CTE c2 WHERE 	c2.RowNum=CTE.RowNum+1)),0) AS varchar(10))
--,      EventDate= CONVERT(date,Test_Date_Time)
--,      StartTime=CONVERT(time,Test_Date_Time)
--,      EndTime= ISNULL(CONVERT(time,DATEADD(second,CAST((DATEDIFF(s,Test_Date_Time,(SELECT c2.Test_Date_Time
--FROM CTE c2
--WHERE c2.RowNum=CTE.RowNum+1))) as float),Test_Date_Time)) ,(CONVERT(time,Test_Date_Time)))
--,      DiffSec=ISNULL( DATEDIFF(s,Test_Date_Time,(SELECT c2.Test_Date_Time
--FROM CTE c2
--WHERE c2.RowNum=CTE.RowNum+1)),0)
--,      DiffMin=ISNULL(ROUND(CAST((DATEDIFF(s,Test_Date_Time,(SELECT c2.Test_Date_Time
--FROM CTE c2
--WHERE c2.RowNum=CTE.RowNum+1))) as float)/60,2),0)
--FROM CTE 
--ORDER BY CTE.Station, CTE.TL_ID

--select count (CTE.TL_ID) from CTE


---phan 2
--USE [master] GO
--EXEC MASTER.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'SQL16NODEB\SQL2014', @locallogin = NULL , @useself = N'False', @rmtuser = N'sa', @rmtpassword = N'sa'
--GO
--EXEC VNCapacityControl_SPUpdateAll

Create Table #TSTDATA
([RowNum] INT,[TestDate] DATETIME,[Station] varchar(60),[Task] varchar(60),[EventDate] datetime,[StartTime] datetime,[EndTime] datetime,[DiffSec] int, [DiffMin] int, [TAKT] int);


;WITH 
CTE
AS
(
	SELECT ROW_NUMBER()OVER(/*PARTITION BY tl.Station*/ ORDER BY tl.Station,CONVERT(date,last_event_date) , row_ID )As RowNum
	,      tl.*, VNCAPACITYCONTROL.TargetHRS
	FROM ACSEEState.dbo.LociLog tl, VNCapacityControl
	WHERE (last_event_date BETWEEN @from_date AND @to_date)
	--WHERE (Test_Date_Time BETWEEN '04/05/2016 06:00' AND '04/05/2016 10:00')
		AND Station = @Station
		--AND Station like 
		--SUBSTRING(@Station, 0, LEN(rtrim(@Station))-1)
		--'BASCULA_CAL_VERIFY%'

		 AND [VNCapacityControl].productgroup = tl.SAP_Model
)
INSERT INTO  #TSTDATA ([RowNum],[TestDate],[Station],[Task],[EventDate],[StartTime],[EndTime],[DiffSec],[DiffMin], [TAKT])
SELECT CTE.RowNum
,      CONVERT(date,last_event_date) AS TestDate
,      CTE.Station
,	Task=RTRIM(SAP_Model)+'_'+RTRIM(ACS_Serial) +'C'+cast(ISNULL( DATEDIFF(s,last_event_date,(SELECT  c2.last_event_date FROM CTE c2 WHERE 	c2.RowNum=CTE.RowNum+1)),0) AS varchar(10))
,      EventDate= CONVERT(date,last_event_date)
,      StartTime=CONVERT(time,last_event_date)
,      EndTime= ISNULL(CONVERT(time,DATEADD(second,CAST((DATEDIFF(s,last_event_date,(SELECT c2.last_event_date
FROM CTE c2
WHERE c2.RowNum=CTE.RowNum+1))) as float),last_event_date)) ,(CONVERT(time,last_event_date)))
,      DiffSec=ISNULL( DATEDIFF(s,last_event_date,(SELECT c2.last_event_date
FROM CTE c2
WHERE c2.RowNum=CTE.RowNum+1)),0)
,      DiffMin=ISNULL(ROUND(CAST((DATEDIFF(s,last_event_date,(SELECT c2.last_event_date
FROM CTE c2
WHERE c2.RowNum=CTE.RowNum+1))) as float)/60,2),0)
, TaktimeSEC = ISNULL(ROUND((60*60/cast(CTE.TargetHRS as float)),2),0)

FROM CTE -- , VNCapacityControl Ccvn
--ORDER BY CTE.Station, CTE.TL_ID


--WHERE  [VNCapacityControl].ProductGroup = CTE.SAP_Model
--SELECT * FROM [10.84.10.67\SIPLACE_2008R2EX].[PTR].[dbo].[CapacityControl]




--khang add 21 Apr 2016


SELECT * FROM #TSTDATA
--SELECT t.DiffSec from #TSTDATA t
--quartile
select  quartile,max(DiffSec ) as Value
from    (select DiffSec, ntile(4) over (order by DiffSec ) as [quartile]
         from   #TSTDATA) i
--where quartile = 2
group by quartile

--Min
select  @min=max(DiffSec ) --as [my_column], quartile
from    (select DiffSec, ntile(4) over (order by DiffSec ) as [quartile]
         from   #TSTDATA) i
where quartile = 1
group by quartile
--max
select  @Max=max(DiffSec ) --as [my_column], quartile
from    (select DiffSec, ntile(4) over (order by DiffSec ) as [quartile]
         from   #TSTDATA) i
where quartile = 4
group by quartile


--
SELECT @Median=
(
 (SELECT MAX(DiffSec) FROM
   (SELECT TOP 50 PERCENT DiffSec FROM #TSTDATA ORDER BY DiffSec) AS BottomHalf)
 +
 (SELECT MIN(DiffSec) FROM
   (SELECT TOP 50 PERCENT DiffSec FROM #TSTDATA ORDER BY DiffSec DESC) AS TopHalf)
) / 2 
--AS Median

select @Average=AVG(DiffSec)  FROM #TSTDATA  
--mode
SELECT TOP 1 @Mode
=  DiffSec 
FROM   #TSTDATA
WHERE  DiffSec IS Not NULL
GROUP  BY DiffSec
ORDER  BY COUNT(*) DESC


SELECT @Median AS Median
,      @Mode AS Mode
,      @min AS Min
,      @Max AS Max
,      @Average AS Average
--,      @from_date
--,      @to_date
,      60*60/@Median AS SuggestTargetHr
,      420*60/@Median AS SuggestTargetShift

END


/*
exec [amevn_Report_Test_client_statistic] '03/31/2016' , '7' ,23,'COBALTOPERF2'


*/
GO