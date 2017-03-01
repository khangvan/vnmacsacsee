SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_DavesLimits2]
 AS

declare @subtestname char(20)
declare @SAPMODEL char(20)
declare @stationname char(20)
declare @mode int

declare cur_EachModel CURSOR FOR
select 
distinct 
SAP_Model_Name
 from subtestlimits where sap_model_name like '5500%'

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
strLimit,
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
'RFTagVer1',
@SAPMODEL,
'S',
'640.0.0',
' ',
'RF Tag Version',
'davec',
0,
'N',
'6/8/2005'
)

FETCH NEXT from cur_EachModel into @SAPMODEL
end

close cur_EachModel
deallocate cur_EachModel
GO