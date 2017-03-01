SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- Batch submitted through debugger: SQLQuery22.sql|4|0|C:\Users\kvan\AppData\Local\Temp\~vs2920.sql





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[amevn_Report_TestStationOuput_byShift]
	-- Add the parameters for the stored procedure here
	--@boolrealtime bit --	-- @bool = 1 => autoget dateime
	( @datetime Datetime ,
	 @iShift int 
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
    	SET @from_date =  DATEADD(HOUR,@from_hour,(DATEADD(DAY, 0, @datetime)))		set @to_hour = 14		SET @to_date =  DATEADD(HOUR,@to_hour,(DATEADD(DAY, 0, @datetime)))
    END
		IF (@iShift =2)
	BEGIN
		set @from_hour =14
    	SET @from_date =  DATEADD(HOUR,@from_hour,(DATEADD(DAY, 0, @datetime)))		set @to_hour = 22		SET @to_date =  DATEADD(HOUR,@to_hour,(DATEADD(DAY, 0, @datetime)))
    END

			IF (@iShift =3)
	BEGIN
		set @from_hour =22
    	SET @from_date =  DATEADD(HOUR,@from_hour,(DATEADD(DAY, 0, @datetime)))		set @to_hour = 6 --6h next day		SET @to_date =  DATEADD(HOUR,@to_hour,(DATEADD(DAY, 1, @datetime)))
    END


 
	select Station
,Sap_Model
,      COUNT(distinct(ACS_Serial)) as TotalSNTest
,      SUM(case when FP >0 then 1
                           else 0 end) as FirstPass
,      SUM(case when RTP > 0 then 1
                             else 0 end)as Retestpass
,SUM(case when FP >0 then 1
                           else 0 end) +
     SUM(case when RTP > 0 then 1
                             else 0 end) as TotalPass
,      SUM(case when f > 0 then 1
                           else 0 end)as Fail
,      convert (decimal (6,2),(CAST ((SUM(case when FP >0 then 1
                                                          else 0 end)) as float)/
cast ((count (distinct ACS_serial))as float))*100 )as FirstPassYield
, convert (decimal (6,2),(CAST ((SUM(case when FP >0 then 1
                           else 0 end) +
     SUM(case when RTP > 0 then 1
                             else 0 end)) as float)/
cast ((count (distinct ACS_serial))as float))*100 )as RealYield

from (
select Station
,      ACS_Serial
,      SAP_Model
,      case when (sum(case when Pass_Fail='F' and FirstRun='Y' then 1
	                                                           else 0 end)=0) then 1
                                                                              else 0 end as FP
,      case when sum(case when Pass_Fail='F' and FirstRun='Y' then 1
	                                                          else 0 end)=0 then 0
                                                                            else ( sum(case when Pass_Fail='P' then 1
	                                                                                                           else 0 end) - case when (sum(case when Pass_Fail='F' and FirstRun='Y' then 1
		                                                                                                                                                                             else 0 end)=0) then 1
	                                                                                                                                                                                                else 0 end) end as RTP
,      ( COUNT(distinct ACS_Serial)
- ( case when (sum(case when Pass_Fail='F' and FirstRun!='N' then 1
	                                                         else 0 end)=0) then 1
                                                                            else 0 end )
- ( case when sum(case when Pass_Fail='F' and FirstRun!='N' then 1
	                                                        else 0 end)=0 then 0
                                                                          else (sum(case when Pass_Fail='P' then 1
	                                                                                                        else 0 end) - case when (sum(case when Pass_Fail='F' and FirstRun!='N' then 1
		                                                                                                                                                                           else 0 end)=0) then 1
	                                                                                                                                                                                              else 0 end) end ) )
as f

from [TestLog]
WHERE dbo.TestLog.Test_Date_Time BETWEEN @from_date  AND @to_date
--AND Station ='HLGUNTEST1i1        '
group by Station
,        ACS_Serial
,        SAP_Model
) as a
group by Station, a.SAP_Model
order by station, sap_model,FirstPassYield , Fail

END
GO