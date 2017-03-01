SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_risk_calculator]
 AS

declare @tempmodel char(20)
declare @model char(20)

declare @maxgooddate datetime
declare @maxgoodserial char(20)

declare cur_models CURSOR FOR
select  sap_modelname from risktablebuilt2

open cur_models

fetch next from cur_models into @tempmodel

while @@FETCH_STATUS = 0
begin
set @model = substring(@tempmodel,2,len(@tempmodel) - 1)

truncate table risktemp

insert into risktemp
(
 risktype, risk_acs_serial, risk_station, 
risk_action, risk_part_no, risk_scanned_serial, 
risk_action_date, risk_start_station, risk_start_mfg, 
risk_psc_serial, risk_end_mfg, risk_sales_order, 
risk_line_item, risk_sap_model_name, risk_part_no_count, 
risk_part_no_name, risk_station_name, risk_machine_name
)
select 'prelim',asylog.acs_serial, asylog.station, asylog.action, asylog.added_part_no,
asylog.scanned_serial, asylog.action_date,assemblies.start_station, assemblies.start_mfg,
assemblies.psc_serial, assemblies.end_mfg, assemblies.sales_order, assemblies.line_item,
products.sap_model_name, catalog.part_no_count, catalog.part_no_name, 
stations.station_name, stations.machine_name from asylog
inner join assemblies on asylog.acs_serial = assemblies.acs_serial
inner join products on sap_model_no = sap_count
inner join catalog on added_part_no = part_no_count
inner join stations on station=station_count
where 
 action_date < '10/25/2008 1:00 PM'
and sap_model_name =@model


select @maxgooddate = max(risk_action_date) from risktemp


select @maxgoodserial = risk_acs_serial from risktemp where risk_action_date = @maxgooddate

insert into riskanalysis
(
risktype, risk_acs_serial, risk_station, 
risk_action, risk_part_no, risk_scanned_serial, 
risk_action_date, risk_start_station, risk_start_mfg, 
risk_psc_serial, risk_end_mfg, risk_sales_order, 
risk_line_item, risk_sap_model_name, risk_part_no_count, 
risk_part_no_name, risk_station_name, risk_machine_name
)
select 'lastgoodbuild',
 risk_acs_serial, risk_station, 
risk_action, risk_part_no, risk_scanned_serial, 
risk_action_date, risk_start_station, risk_start_mfg, 
risk_psc_serial, risk_end_mfg, risk_sales_order, 
risk_line_item, risk_sap_model_name, risk_part_no_count, 
risk_part_no_name, risk_station_name, risk_machine_name
from risktemp
where risk_acs_serial=@maxgoodserial


insert into riskanalysis
(
risktype, risk_acs_serial, risk_station, 
risk_action, risk_part_no, risk_scanned_serial, 
risk_action_date, risk_start_station, risk_start_mfg, 
risk_psc_serial, risk_end_mfg, risk_sales_order, 
risk_line_item, risk_sap_model_name, risk_part_no_count, 
risk_part_no_name, risk_station_name, risk_machine_name
)
select 'afterchange',
asylog.acs_serial, asylog.station, asylog.action, asylog.added_part_no,
asylog.scanned_serial, asylog.action_date,assemblies.start_station, assemblies.start_mfg,
assemblies.psc_serial, assemblies.end_mfg, assemblies.sales_order, assemblies.line_item,
products.sap_model_name, catalog.part_no_count, catalog.part_no_name, 
stations.station_name, stations.machine_name from asylog
inner join assemblies on asylog.acs_serial = assemblies.acs_serial
inner join products on sap_model_no = sap_count
inner join catalog on added_part_no = part_no_count
inner join stations on station=station_count
where 
 action_date  > '10/25/2008 8:00 PM'
and action_date < '10/28/2008 12:30 PM'
and sap_model_name =@model


fetch next from cur_models into @tempmodel
end

close cur_models
deallocate cur_models
GO