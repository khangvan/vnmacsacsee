﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- [amevn_TrackingAllDataSerial] 'SK100969144'
-- =============================================
CREATE PROCEDURE [dbo].[amevn_TrackingAllDataSerial]
	@Serial varchar(30) ='SK100969144'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..##Tracktb') IS NOT NULL
 drop TABLE ##Tracktb
  

--assy data
SELECT     cast('Assy' as varchar(30))  ProcessType, cast('' as varchar(30))  ProdOrder,cast('' as varchar(30)) Sap_Model,  asylog.ACS_Serial,cast('' as varchar(30)) BoxNumber, Catalog.Part_No_Name Sub_Model,  asylog.Scanned_Serial Sub_Serial,  Stations.Station_Name, asylog.Action_date ProcessDate, '' TestResult
INTO ##Tracktb
FROM            asylog INNER JOIN
                         Catalog ON asylog.Added_Part_No = Catalog.Part_No_Count INNER JOIN
                         Stations ON asylog.Station = Stations.Station_Count

						 where acs_serial in
						 (
					@Serial
						 )
						 
						 ORDER BY  ACTION_DATE DESC, STATION_NAME;

						 
-- test data
--

DECLARE	@return_table TABLE (
RowNum varchar(30), ACS_Serial varchar(30), SAP_Model varchar(30), Station varchar(30), Pass_Fail varchar(30), Test_Date_Time datetime, tl_id int, DataFlow varchar(255)

					   )

INSERT into @return_table  EXEC  [dbo].amevn_serialcheck @Serial


INSERT INTO ##Tracktb
(
 ProcessType, 
ProdOrder,
Sap_Model,  
ACS_Serial,
BoxNumber
,Sub_Model
,Sub_Serial
,Station_Name
, ProcessDate
, TestResult

)
SELECT 
'TEST' ProcessType,	
'' ProdOrder,
SAP_Model,
ACS_Serial,  
'' BoxNumber
,'' Sub_Model
,'' Sub_Serial,
Station, 
Test_Date_Time ProcessDate
,Pass_Fail TestResult


FROM @return_table



--select * from sys.servers
--exec amevn_serialcheck 'SK100969144'--@Serial
    --

-- packing data

  --select  top 1* from [10.84.10.67\SIPLACE_2008R2EX].FFCPACKING.dbo.PACKINGRECORD

INSERT INTO ##Tracktb
(
 ProcessType, 
ProdOrder,
Sap_Model,  
ACS_Serial,
BoxNumber
,Sub_Model
,Sub_Serial
,Station_Name
, ProcessDate
,TestResult
)

SELECT     
'Packing'  ProcessType, 
pONumber ProdOrder,
Model Sap_Model,  
Serial ACS_Serial,
 BoxNumber
, '' Sub_Model
,  '' Sub_Serial
, 'PackingStation' Station_Name
, PackingDateTime ProcessDate
,'' TestResult

FROM [10.84.10.67\SIPLACE_2008R2EX].FFCPACKING.dbo.PACKINGRECORD
WHERE serial = @Serial--'SK100969144'    --

select * from ##Tracktb
order by processdate desc
END
GO