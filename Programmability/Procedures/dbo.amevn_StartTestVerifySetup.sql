SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[amevn_StartTestVerifySetup]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--SELECT DISTINCT tl.SAP_Model, tl.Station
--  FROM [VNMACSRPT2].[RStaging].[dbo].[DB1_testlog] tl
--  WHERE tl.Test_Date_Time >= dateadd(mm,-1, getdate())
--  AND sap_model <> ''
  
--GO

---- is start
--SELECT rn=(row_number() over(PARTITION BY sap_model, part_number ORDER BY bom_date_time desc)),* FROM (
--SELECT distinct PAR.ProdOrder,PAR.Qty
--, PAR.SAP_Model, PAR.Part_Number,PAR.Station, PAR.BOM_Date_Time FROM ACSEEClientState..Parts_Level AS PAR 
--WHERE station LIKE '%START%'
--AND PAR.ProdOrder <>''
--AND PAR.SAP_Model <> ''
--AND part_number <> 'INFO'
--)tb1
 

 
---- do join

--; WITH cte AS 
--(
--SELECT rn=(row_number() over(PARTITION BY sap_model, part_number ORDER BY bom_date_time desc)),* FROM (
--SELECT distinct PAR.ProdOrder,PAR.Qty
--, PAR.SAP_Model, PAR.Part_Number,PAR.Station, PAR.BOM_Date_Time FROM ACSEEClientState..Parts_Level AS PAR 
--WHERE station LIKE '%START%'
--AND PAR.ProdOrder <>''
--AND PAR.SAP_Model <> ''
--AND part_number <> 'INFO'
--)tb1

--)-- end cte
--SELECT sap_model Top_Model, /*part_number,*/ station Start_Station
--,tld.*
--FROM cte
--inner join
--(
--SELECT DISTINCT tl.SAP_Model Test_Model, tl.Station Test_Station
--  FROM [VNMACSRPT2].[RStaging].[dbo].[DB1_testlog] tl
--  WHERE tl.Test_Date_Time >= dateadd(mm,-1, getdate())
--  AND sap_model <> ''
--) tld
--on tld.Test_Model =cte.part_number
-- WHERE rn =1
-- order by top_model

 --- do check start
 
 IF OBJECT_ID('tempdb..##StartTest') IS NOT NULL
 DROP TABLE ##StartTest
  
  
 ; WITH cte AS 
(
SELECT rn=(row_number() over(PARTITION BY sap_model, part_number ORDER BY bom_date_time desc)),* FROM (
SELECT distinct PAR.ProdOrder,PAR.Qty
, PAR.SAP_Model, PAR.Part_Number,PAR.Station, PAR.BOM_Date_Time FROM ACSEEClientState..Parts_Level AS PAR 
WHERE station LIKE '%START%'
AND PAR.ProdOrder <>''
AND PAR.SAP_Model <> ''
AND part_number <> 'INFO'
)tb1

)-- end cte
SELECT

   cte.sap_model as Top_Model
,tld.Test_Model, tld.Test_station
into ##StartTest
FROM cte
inner join
(
SELECT DISTINCT tl.SAP_Model Test_Model, substring(tl.Station,1,4) Test_Station
  FROM [VNMACSRPT2].[RStaging].[dbo].[DB1_testlog] tl
  WHERE tl.Test_Date_Time >= dateadd(mm,-1, getdate())
  AND sap_model <> ''
) tld
on tld.Test_Model =cte.part_number
---
left join
(
select * from tffc_kicksub 

)ks
on (ks.TFFC_KICKSUB_Part= tld.Test_Model
and ks.TFFC_KICKSUB_Model= cte.Sap_Model)
--
 WHERE rn =1
 --order by top_model

 ----
  IF OBJECT_ID('tempdb..##StartTestRS') IS NOT NULL
 DROP TABLE ##StartTestRS

 SELECT DISTINCT top_model, Test_Model 
 , ks.TFFC_KICKSUB_Station, ks.TFFC_KICKSUB_Location
 INTO ##StartTestRS
 FROM ##StartTest AS S
 LEFT JOIN 
 (
 SELECT k.TFFC_KICKSUB_Station,k.TFFC_KICKSUB_Location, k.TFFC_KICKSUB_Model, k.TFFC_KICKSUB_Part FROM tffc_kicksub k
 ) ks 
 ON ks.TFFC_KICKSUB_Model=s.Top_Model
 AND ks.TFFC_KICKSUB_Part= s.Test_Model

 SELECT * FROM ##StartTestRS ORDER BY ##StartTestRS.TFFC_KICKSUB_Location


 ------ update for not local
 --UPDATE TFFC_KICKSUB
 --SET TFFC_KICKSUB_Location ='Local'
 --FROM dbo.##StartTestRS rs
 --LEFT JOIN TFFC_KICKSUB
 -- on TFFC_KICKSUB_Model= rs.Top_Model
 --and TFFC_KICKSUB_Part =rs.Test_Model
 -- WHERE rs.TFFC_KICKSUB_Location <>'Local'


 -----insert
 --INSERT INTO tffc_kicksub (
 --TFFC_KICKSUB_Model, TFFC_KICKSUB_Part, TFFC_KICKSUB_Station, TFFC_KICKSUB_Location
 --)
 -- SELECT top_model TFFC_KICKSUB_Model, Test_Model TFFC_KICKSUB_Part,'DLVN' TFFC_KICKSUB_Station,'Local' TFFC_KICKSUB_Location FROM dbo.##StartTestRS AS TFF
 --WHERE TFF.TFFC_KICKSUB_Location is NULL




 --- amevn_StartTestVerifySetup
 -- select * from tffc_kicksub where TFFC_KICKSUB_Model like 'm22%'
END
GO