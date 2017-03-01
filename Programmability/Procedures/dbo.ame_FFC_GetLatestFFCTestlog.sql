SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_FFC_GetLatestFFCTestlog]
 AS
set nocount on

select 
testlog.acs_serial,
testlog.sap_model,
testlog.station,
testlog.Test_ID,
testlog.Pass_Fail,
testlog.firstrun,
testlog.Test_Date_Time,
testlog.ACSEEMode,
testlog.TL_ID
from ffc_backflush_Current 
inner join assemblies on ffc_backflush_Serialno = psc_serial
inner join products on sap_model_no = sap_count
inner join stations on start_station = station_count
inner join testlog 
on assemblies.acs_serial = testlog.acs_serial
and testlog.station = stations.station_name
and products.sap_model_name = sap_model
where ffc_backflush_serialno='C40001063'
GO