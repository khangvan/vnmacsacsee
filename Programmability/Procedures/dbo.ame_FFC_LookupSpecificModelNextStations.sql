SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_LookupSpecificModelNextStations]
@model char(20)
 AS
--select * from subtestlimits where sap_model_name in
--( 
--select FFC_Lookup_Model from FFC_LookupModels
--)


select distinct sap_model,next_station_name, count(*) as num
from [ACSEEState].[dbo].locilog where sap_model = @model
group by sap_model,next_station_name
order by next_station_name
GO