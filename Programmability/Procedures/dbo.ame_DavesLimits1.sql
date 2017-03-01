SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_DavesLimits1]
 AS

declare @subtestname char(20)
declare @SAPMODEL char(20)
declare @stationname char(20)
declare @mode int

declare cur_EachModel CURSOR FOR
select distinct sap_model_name from subtestlimits where station_name = 'F44xxFulFill'
open cur_EachModel

FETCH NEXT from cur_EachModel into  @SAPMODEL
WHILE @@FETCH_STATUS = 0
begin

insert into subtestlimits
(
Station_Name,
subtest_name,
sap_model_name,
limit_type,
Units,
Description,
Author,
ACSEEMode,
SPCParm,
Limit_Date
)
values
(
'F44xxFulFill',
'ScriptName',
@SAPMODEL,
'S',
' ',
'XFR Scrip file',
'davec',
0,
'N',
'6/3/2005'
)

FETCH NEXT from cur_EachModel into @SAPMODEL
end

close cur_EachModel
deallocate cur_EachModel
GO