SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[amevn_reportassyfromFFC]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  BEGIN TRAN

BEGIN TRAN

BEGIN TRAN

IF OBJECT_ID('TEMPDB..##tempSeriallist') IS NOT NULL
BEGIN
/*Then it exists*/ DROP TABLE ##tempSeriallist
END


SELECT  TFF.TFFC_SerialNumber  into ##tempSeriallist FROM dbo.TFFC_SerialNumbers AS TFF
WHERE tff.TFFC_ProdOrder IN 
(
'000100900868'
,'000100900866'
,'000100900869'
,'000100900870'

)-- SELECT * FROM ##tempSeriallist


IF OBJECT_ID('TEMPDB..##tempSerialWtst') IS NOT NULL
BEGIN
/*Then it exists*/ DROP TABLE ##tempSerialWtst
END

    ---ffc 2 base - assy data
    ; WITH cte AS (
	SELECT        TFFC_ProdOrder as [Production Order No ], TFFC_Material as [Product Model], TFFC_SerialNumber as [Product Serial]
 ,TFFC_ConsumedDate AS [Config Pass At],a.ACS_Serial as [FFC ACS Serial],  
 Part_No_Name as [SubAssy Model], a.Scanned_Serial as [SubAssy Serial], a.Action_Date AS [Assy Done At]
 FROM            asylog a INNER JOIN
                         Catalog ON a.Added_Part_No = Catalog.Part_No_Count INNER JOIN
                         Stations ON a.Station = Stations.Station_Count INNER JOIN
						 TFFC_SerialNumbers ON TFFC_ACSSErial=ACS_Serial
						                                         where 
		
										 TFFC_SerialNumber in
										(
										SELECT * FROM ##tempSeriallist
										)
										
										    and a.Scanned_Serial<>'')-- done cte FFC-BASE

										    SELECT cte.*
										    ,ltd.Station, ltd.Test_Date_Time AS [Test Done at],ltd.Pass_Fail,ltd.FirstRun,ltd.tl_id
											into ##tempSerialWtst
											FROM cte LEFT JOIN 
											(--1
											SELECT ROW_NUMBER()OVER(PARTITION BY TES.ACS_Serial, TES.SAP_Model /*, TES.Station remove cause move*/ ORDER BY TES.Test_Date_Time DESC )As rn
													   ,* FROM dbo.TestLog AS TES WHERE acs_serial in( SELECT   [subassy serial] FROM cte)
										    ) 
													   
													  ltd--1 last test data
										ON  (cte.[subassy serial] = ltd.ACS_Serial
										AND ltd.rn=1
										
										)-- select * from ##tempSerialWtst
										

--
IF OBJECT_ID('tempdb..##stl') IS NOT NULL
/*Then it exists*/ DROP TABLE ##stl

	select  * into ##stl from vnmacsrpt2.rstaging.dbo.db1_subtestlog stl
where stl.tl_id IN (
				select tl.tl_id from ##tempSerialWtst tl
				)




--
select * from ##tempSerialWtst tl
INNER JOIN ##stl stl
ON tl.tl_id = stl.tl_id
WHERE stl.subtest_name ='beeper'

	




ROLLBACK
END
GO