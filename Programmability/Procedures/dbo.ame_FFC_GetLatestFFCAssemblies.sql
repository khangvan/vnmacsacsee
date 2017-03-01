SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_FFC_GetLatestFFCAssemblies]
 AS
set nocount on

select 
assemblies.acs_serial,
products.sap_model_name  as sap_model,
stations.station_name as station,
assemblies.Top_Model_Prfx,
assemblies.Start_Mfg,
assemblies.PSC_Serial,
assemblies.End_Mfg,
assemblies.Sales_Order,
assemblies.Line_Item,
assemblies.Current_State,
assemblies.assem_id from ffc_backflush_Current 
inner join assemblies on ffc_backflush_Serialno = psc_serial
inner join products on sap_model_no = sap_count
inner join stations on start_station = station_count
where ffc_backflush_serialno='C40001063'
GO