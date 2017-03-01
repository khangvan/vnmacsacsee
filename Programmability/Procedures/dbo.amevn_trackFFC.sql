SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
/*
SVC006053454        	740060900           	SVC006043713        
SVC006053454        	740061000           	G15HALRKH           
exec amevn_trackFFC 'vnc5350578', '740060900'
exec amevn_trackFFC 'vnc5350578', '740061000'
*/
-- =============================================
CREATE PROCEDURE [dbo].[amevn_trackFFC]
@G nvarchar(30), @model nvarchar(30) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH cte AS (
	SELECT        
	--TFFC_ProdOrder as Orders, TFFC_Material as SapModel, TFFC_SerialNumber as Sap_serial, 
 a.ACS_Serial as ACS_Serial,  Part_No_Name as Sub_SapModel, a.Scanned_Serial as Sub_Serial
 --, a.Action_Date
 FROM            asylog a INNER JOIN
                         Catalog ON a.Added_Part_No = Catalog.Part_No_Count INNER JOIN
                         Stations ON a.Station = Stations.Station_Count INNER JOIN
						 TFFC_SerialNumbers ON TFFC_ACSSErial=ACS_Serial
						                                         where 
		
										 TFFC_SerialNumber in
										(
										@G--'vnc5350578'
										)
										
										and a.Scanned_Serial<>''
										)

										SELECT CTE.Sub_Serial FROM cte AS CTE 
										WHERE CTE.Sub_SapModel =@model
END

GO