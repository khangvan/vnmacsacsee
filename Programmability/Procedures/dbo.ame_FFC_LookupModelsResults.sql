SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_LookupModelsResults]
@Vendor char(10) = '104341'
 AS
select * from subtestlimits where sap_model_name in
( 
select FFC_Lookup_Model from FFC_LookupModels
)

and 
( 
(station_name in
(
select substring(EUGENE_StationName,1,len(EUGENE_StationName) - 1)  from FFC_EUGPAN_Mapping where Vendor_ID = @Vendor
)
)
or
(station_name in
(
select EUGENE_StationName  from FFC_EUGPAN_Mapping where Vendor_ID = @Vendor
)
)
)


--select distinct sap_model,next_station_name from [ACSEEState].[dbo].locilog where sap_model in
--( 
--select FFC_Lookup_Model from FFC_LookupModels
--)
GO