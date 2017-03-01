SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_FFC_GetLatestFFCSubtestlog]
 AS
set nocount on

select 
subtestlog.acs_serial,
subtestlog.station,
subtestlog.subtest_name,
subtestlog.Test_ID,
subtestlog.Pass_Fail,
subtestlog.strValue,
subtestlog.intValue,
subtestlog.floatValue,
subtestlog.Units,
subtestlog.Comment,
subtestlog.STL_ID
from ffc_backflush_Current 
inner join assemblies on ffc_backflush_Serialno = psc_serial
inner join products on sap_model_no = sap_count
inner join stations on start_station = station_count
inner join testlog 
on assemblies.acs_serial = testlog.acs_serial
and testlog.station = stations.station_name
and products.sap_model_name = sap_model
inner join subtestlog on testlog.test_id = subtestlog.test_id
where ffc_backflush_serialno='C40001063'
GO