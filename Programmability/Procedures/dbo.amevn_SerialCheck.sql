SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[amevn_SerialCheck] 
@SerialCheck varchar(30) 
--@SerialCheck varchar(30) ='SVC008963885'
/*
test: exec amevn_SerialCheck 'SVC009180397' NG- Fail : Should be : [3]_HHGUNTEST_P  | Actual:  [1]_G44USBTEST_F, [2]_HHGUNTEST_P, [3]_G2DPOWER_P
exec amevn_SerialCheck 'SVC009334266'
*/
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


DECLARE @SerialCheckIn varchar(30)
SET @SerialCheckIn = @SerialCheck

/*
INIT:
select top 20 * from testlog where Station ='g44usbtest1'
and Test_Date_Time between '2016-12-05 00:00:00' and '2016-12-05 23:59:59'

select * from testlog where acs_serial ='SVC009180397        '

PROCUDURE RULE:
1ST: G44USBTEST1         - BY INSTANCE NAME G44USBTEST            
2ND: HHGUNTEST1          - HHGUNTEST
USING:
- PRINTPACK
- START STATION
1- insstancing station by len-1 ex: SELECT LEFT('HHGUNTEST1', len('HHGUNTEST1')-1)
2- Set RN for first record, order by datetime desc
3- Set Rownum for lastest order by station

*/
/*temp local table*/

--DECLARE @SerialCheck varchar(30)
--SET @SerialCheck='SVC009180397'

IF OBJECT_ID('tempdb..#TestData') IS NOT NULL
 drop TABLE #TestData
  

;WITH cte AS (
select 
ROW_NUMBER()OVER(PARTITION BY sap_model,ACS_SERIAL, LEFT(station, len(station)-1) ORDER BY Test_Date_Time desc  )As RN
,ACS_Serial 
, SAP_Model
, LEFT(station, len(station)-1) AS Station
,Pass_Fail
,Test_Date_Time
,tl_id
 from testlog 
 WHERE  acs_serial =@SerialCheckIn--'SVC009180397'
  AND SAP_Model NOT IN ('EXITORT', 'ENTERORT')
)
 SELECT ROW_NUMBER()OVER(ORDER BY Test_Date_Time desc  )As RowNum 
 ,ACS_Serial 
, SAP_Model
, Station
,Pass_Fail
,Test_Date_Time
,tl_id
 /*insert into temp local table*/ INTO #TestData
  from cte AS CTE
 WHERE rn =1-- last data record
 --AND acs_serial =@SerialCheckIn--'SVC009180397'
 ORDER BY CTE.test_date_time desc
 
 -- Test:   select * from #TestData

 /*Create Data TEST Flow*/
 DECLARE @DTFlow varchar(100)
  select @DTFlow=(select   DISTINCT
  STUFF((SELECT DISTINCT ', ' + QUOTENAME(y.RowNum) +'_'+ rtrim(y.Station)+'_'+rtrim(y.Pass_Fail)
            FROM #TestData y
		  --ORDER BY y.RowNum
            --WHEre MAS.ACS_Serial=y.ACS_Serial
		 
		  FOR XML PATH('')), 1, 1, '') [Data Test Flow]
  from #TestData MAS)
  --SELECT @DTFlow AS DataFlow
 
 select *, @DTFlow AS DataFlow from #TestData
 




END
GO