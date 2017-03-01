SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




-- Batch submitted through debugger: SQLQuery22.sql|4|0|C:\Users\kvan\AppData\Local\Temp\~vs2920.sql





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[amevn_Report_TestStationOuput_byShift_client]
	-- Add the parameters for the stored procedure here
	--@boolrealtime bit --	-- @bool = 1 => autoget dateime
	( @datetimego Datetime ,
	 @iShift int ,
	 @Station varchar(30)
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

	--DECLARE @currenthr= gethour()
	IF (@iShift =1)
	BEGIN
		set @from_hour =6
    	SET @from_date =  DATEADD(HOUR,@from_hour,(DATEADD(DAY, 0, @datetimego)))
		set @to_hour = 14
		SET @to_date =  DATEADD(HOUR,@to_hour,(DATEADD(DAY, 0, @datetimego)))
    END
		IF (@iShift =2)
	BEGIN
		set @from_hour =14
    	SET @from_date =  DATEADD(HOUR,@from_hour,(DATEADD(DAY, 0, @datetimego)))
		set @to_hour = 22
		SET @to_date =  DATEADD(HOUR,@to_hour,(DATEADD(DAY, 0, @datetimego)))
    END

			IF (@iShift =3)
	BEGIN
		set @from_hour =22
    	SET @from_date =  DATEADD(HOUR,@from_hour,(DATEADD(DAY, 0, @datetimego)))
		set @to_hour = 6 --6h next day
		SET @to_date =  DATEADD(HOUR,@to_hour,(DATEADD(DAY, 1, @datetimego)))
    END


 
--	DECLARE @from_date datetime
--DECLARE @to_date datetime

--SET @from_date ='03/30/2016 06:00'
--SET @to_date ='03/30/2016 09:15'

--SELECT ROW_NUMBER()OVER(PARTITION BY tl.SAP_Model ORDER BY TL_ID )As RowNum
--    , *
--    FROM dbo.TestLog tl 
--	WHERE Test_Date_Time BETWEEN @from_date  AND @to_date
--AND Station ='COBALTOPERF2'
;

WITH CTE AS (
    SELECT ROW_NUMBER()OVER(PARTITION BY tl.SAP_Model ORDER BY TL_ID )As RowNum
    , *
    FROM dbo.TestLog tl 
	WHERE Test_Date_Time BETWEEN @from_date  AND @to_date
AND Station =@Station
)
SELECT 
CTE.RowNum
,CTE.Station
,	Task=RTRIM(SAP_Model)+'_'+RTRIM(ACS_Serial) +'_'+FirstRun+'_'+Pass_Fail+'C'+cast(ISNULL( DATEDIFF(s,Test_Date_Time,(SELECT  c2.Test_Date_Time FROM CTE c2 WHERE 	c2.RowNum=CTE.RowNum+1)),0) AS varchar(10))
    
	,EventDate= CONVERT(date,Test_Date_Time) 
	,StartTime=CONVERT(time,Test_Date_Time) 
	,EndTime= ISNULL(CONVERT(time,DATEADD(second,CAST((DATEDIFF(s,Test_Date_Time,(SELECT  c2.Test_Date_Time FROM CTE c2 WHERE 
	c2.RowNum=CTE.RowNum+1))) as float)-1,Test_Date_Time))  ,(CONVERT(time,Test_Date_Time))) 
	,DiffSec=ISNULL( DATEDIFF(s,Test_Date_Time,(SELECT  c2.Test_Date_Time FROM CTE c2 WHERE 	c2.RowNum=CTE.RowNum+1)),0)
	,DiffMin=ISNULL(ROUND(CAST((DATEDIFF(s,Test_Date_Time,(SELECT  c2.Test_Date_Time FROM CTE c2 WHERE 
	c2.RowNum=CTE.RowNum+1))) as float)/60,2),0)
	

	
    
    
FROM CTE 
--ORDER BY [Name],[RowNum]

WHERE Test_Date_Time BETWEEN @from_date  AND @to_date
AND Station =@Station

ORDER BY CTE.TL_ID




END
GO