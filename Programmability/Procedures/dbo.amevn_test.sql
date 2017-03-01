SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*
test here

-- exec amevn_test '03/31/2016 06:00' , '03/31/2016 06:15' 

*/

-- =============================================
CREATE PROCEDURE [dbo].[amevn_test]
-- Add the parameters for the stored procedure here
--@boolrealtime bit --	-- @bool = 1 => autoget dateime
(
-- @datetimego DATETIME
 @from_time datetime
, @to_time DATETIME
-- ,@Station varchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- input declare
	DECLARE @from_date DATETIME
	DECLARE @to_date DATETIME

	--BEGIN
	--	SET @from_date = DAteadd(minute, 0, DATEADD(HOUR, @from_time, (DATEADD(DAY, 0, @datetimego))))
	--	SET @to_date = DAteadd(second, 0, DAteadd(minute, 0, DATEADD(HOUR, @to_time, (DATEADD(DAY, 0, @datetimego)))))
	--END

	--DECLARE @currenthr= gethour()
	--IF (@iTime24h =1)
	--BEGIN
	--	set @from_hour =6
	--   	SET @from_date =  DATEADD(HOUR,@from_hour,(DATEADD(DAY, 0, @datetimego)))
	--	set @to_hour = 14
	--	SET @to_date =  DATEADD(HOUR,@to_hour,(DATEADD(DAY, 0, @datetimego)))
	--   END
	--	IF (@iShift =2)
	--BEGIN
	--	set @from_hour =14
	--   	SET @from_date =  DATEADD(HOUR,@from_hour,(DATEADD(DAY, 0, @datetimego)))
	--	set @to_hour = 22
	--	SET @to_date =  DATEADD(HOUR,@to_hour,(DATEADD(DAY, 0, @datetimego)))
	--   END
	--		IF (@iShift =3)
	--BEGIN
	--	set @from_hour =22
	--   	SET @from_date =  DATEADD(HOUR,@from_hour,(DATEADD(DAY, 0, @datetimego)))
	--	set @to_hour = 6 --6h next day
	--	SET @to_date =  DATEADD(HOUR,@to_hour,(DATEADD(DAY, 1, @datetimego)))
	--   END
	--	DECLARE @from_date datetime
	--DECLARE @to_date datetime
	--SET @from_date ='03/30/2016 06:00'
	--SET @to_date ='03/30/2016 09:15'
	--SELECT ROW_NUMBER()OVER(PARTITION BY tl.SAP_Model ORDER BY TL_ID )As RowNum
	--    , *
	--    FROM dbo.TestLog tl
	--	WHERE Test_Date_Time BETWEEN @from_date  AND @to_date
	--AND Station ='COBALTOPERF2'
	;;

	WITH CTE
	AS
	(
		--SELECT ROW_NUMBER()OVER(PARTITION BY CONVERT(date,Test_Date_Time) , tl.SAP_Model ORDER BY TL_ID )As RowNum
		--SELECT ROW_NUMBER()OVER(PARTITION BY CONVERT(date,Test_Date_Time) , tl.Station ORDER BY tl.Station, tl.TL_ID )As RowNum
		SELECT ROW_NUMBER() OVER (
		PARTITION BY tl.Station ORDER BY CONVERT(DATE, Test_Date_Time)
		,tl.Station
		,TL_ID
		) AS RowNum
		,      *
		FROM dbo.TestLog tl
		WHERE (
			Test_Date_Time BETWEEN @from_time
			AND @to_time
			)
		--		AND Station = @Station
		--,'COBALTOPERF2')
	)
	SELECT 
	--CTE.RowNum,
	     CONVERT(DATE, Test_Date_Time) AS TestDate
	,      CTE.Station
	,      Task = RTRIM(SAP_Model) + '_' + RTRIM(ACS_Serial) + '_' + FirstRun + '_' + Pass_Fail + 'C' + cast(ISNULL(DATEDIFF(s, Test_Date_Time, (
	SELECT c2.Test_Date_Time
	FROM CTE c2
	WHERE c2.RowNum = CTE.RowNum + 1
	)), 0) AS VARCHAR(10))
	,      EventDate = CONVERT(DATE, Test_Date_Time)
	,      StartTime = CONVERT(TIME, Test_Date_Time)
	,      EndTime = ISNULL(CONVERT(TIME, DATEADD(second, CAST((
	DATEDIFF(s, Test_Date_Time, (
	SELECT c2.Test_Date_Time
	FROM CTE c2
	WHERE c2.RowNum = CTE.RowNum + 1
	))
	) AS FLOAT), Test_Date_Time)), (CONVERT(TIME, Test_Date_Time)))
	,      DiffSec = ISNULL(DATEDIFF(s, Test_Date_Time, (
	SELECT c2.Test_Date_Time
	FROM CTE c2
	WHERE c2.RowNum = CTE.RowNum + 1
	)), 0)
	,      DiffMin = ISNULL(ROUND(CAST((
	DATEDIFF(s, Test_Date_Time, (
	SELECT c2.Test_Date_Time
	FROM CTE c2
	WHERE c2.RowNum = CTE.RowNum + 1
	))
	) AS FLOAT) / 60, 2), 0)
	FROM CTE
	--WHERE (Test_Date_Time BETWEEN @from_date AND @to_date)
	--	AND Station in ('COBALTOPERF1','COBALTOPERF2')
	ORDER BY CTE.Station
	,        CTE.TL_ID
END

GO