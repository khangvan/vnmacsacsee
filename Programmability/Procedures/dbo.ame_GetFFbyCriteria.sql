SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_GetFFbyCriteria] 
@startDate varchar(80),
@endDate varchar(80),
@startSerial varchar(80),
@endSerial varchar(80),
@strTechnician varchar(80),
@iFru int,
@iAction int,
@iOrigin int,
@test varchar(80),
@line varchar(80),
@station varchar(80),
@onlyuntouched int,
@rvalue int OUTPUT
AS
set nocount on

declare @sql varchar(8000)
declare @legacysql varchar(4000)
declare @type int
declare @SAP_Model varchar(80)
declare @inPcb int

declare @abstartDate varchar(80)
declare @abendDate varchar(80)


/*
select @SAP_Model = 
SAP_Model
from RawFruFailureLog
inner join testlog on RawFruFailureLog.FLG_TL_ID = TL_ID
WHERE ACS_Serial = @serial
order by FLG_FailureLogDate



set @type =1
if @SAP_Model like '3-%'
set @type = 2 
*/

--set @inPCB = select TST_fInPCB from 


set @abstartDate =  LTRIM(RTRIM(str(DATEPART(mm, @startDate))))  + '/' +  LTRIM(RTRIM(str(DATEPART(dd, @startDate)))) + '/' + LTRIM(RTRIM(str(DATEPART(yy, @startDate))))

set @abstartDate = @abstartDate + ' 12:00:00 AM'
print @abstartDate 


set @abendDate =  LTRIM(RTRIM(str(DATEPART(mm, @endDate))))  + '/' +  LTRIM(RTRIM(str(DATEPART(dd, @endDate)))) + '/' + LTRIM(RTRIM(str(DATEPART(yy, @endDate))))
set @abendDate = @abendDate + ' 11:59:59 PM'
print @abendDate 


set @sql = 'select FLG_FailureLogDate,  FLG_ORT, SAP_Model, FLG_ACSSN, FLG_Station, FLG_Failure, '

set @sql = @sql + ' FLG_Critical, RFU_cFruCode, RFU_FruDescription, RAN_ActCode,  RAN_Description, '
set @sql = @sql + ' FLG_Comments, OCD_cCode, OCD_Desc, FLG_RootCauseComment, FLG_RootCauseOwner, '
set @sql = @sql + 'FLG_PreventativeAction, FLG_FL_ID,  FLG_Touched, FLG_Technician, TST_fInPCB,''A'' '
set @sql = @sql + ' from RawFruFailureLog '
set @sql = @sql + '  inner join testlog on RawFruFailureLog.FLG_TL_ID = TL_ID '
set @sql = @sql + '  inner join SAP_NewRepairFrus on FLG_Fru_ID = RFU_Fru_ID '
set @sql = @sql + '  inner join RepairAction on FLG_RepairAction_ID = RAN_RepairAction_ID '
set @sql = @sql + ' inner  join OriginCodes on FLG_OriginCode_ID = OCD_ID '
set @sql = @sql + ' inner join Tests on STN_Name = FLG_Station '
set @sql = @sql +   '  inner join Stations on FLG_Station= Station_Name '
set @sql = @sql + '  inner join MfgLine on MfgLine.MLN_MfgLine_ID = Stations.STN_MfgLine_ID '
set @sql = @sql + ' WHERE '
set @sql = @sql + '  FLG_FailureLogDate > ''' +  @abstartDate  + '''' 
set @sql = @sql +  ' and FLG_FailureLogDate < '''  + @abendDate + ''''
 




set @legacysql = 'select FLG_FailureLogDate, FLG_ORT,FLG_Model,FLG_ACSSN,FLG_Station,FLG_Failure,'
set @legacysql = @legacysql + 'FLG_Critical, RFU_cFruCode,RFU_FruDescription,RAN_ActCode,RAN_Description,'
set @legacysql = @legacysql + 'FLG_Comments,OCD_cCode, OCD_Desc,FLG_RootCauseComment,FLG_RootCauseOwner, '
set @legacysql = @legacysql + 'FLG_PreventativeAction,FLG_FL_ID, FLG_Touched,FLG_Technician,TST_fInPCB,''L'' '
set @legacysql = @legacysql + 'from LegacyFruFailureLog '
set @legacysql = @legacysql + ' inner join SAP_NewRepairFrus on FLG_Fru_ID = RFU_Fru_ID'
set @legacysql = @legacysql + ' inner join RepairAction on FLG_RepairAction_ID = RAN_RepairAction_ID'
set @legacysql = @legacysql + ' inner  join OriginCodes on FLG_OriginCode_ID = OCD_ID'
set @legacysql = @legacysql + '  inner join Tests on STN_Name = FLG_Station'
set @legacysql = @legacysql + '  inner join Stations on FLG_Station= Station_Name '
set @legacysql = @legacysql + '  inner join MfgLine on MfgLine.MLN_MfgLine_ID = Stations.STN_MfgLine_ID '
set @legacysql = @legacysql + '  WHERE '
set @legacysql = @legacysql +   '   FLG_FailureLogDate > ''' +  @abstartDate  + '''' 
set @legacysql = @legacysql +  '  and FLG_FailureLogDate < '''  + @abendDate + ''''







if len(@startSerial) > 0 
begin
   set @sql = @sql + ' and FLG_ACSSN >= ''' + @startSerial  + ''''
   set @legacysql = @legacysql + ' and FLG_ACSSN >= ''' + @startSerial  + ''''
end


if len(@endSerial) > 0 
begin
   set @sql = @sql + ' and FLG_ACSSN <= ''' +  @endSerial + ''''
   set @legacysql = @legacysql + ' and FLG_ACSSN <= ''' +  @endSerial + ''''
end


if len(@strTechnician) > 0
begin
   set @sql = @sql + ' and FLG_Technician = ''' + @strTechnician + ''''
   set @legacysql = @legacysql + ' and FLG_Technician = ''' + @strTechnician + ''''
end

if @iFru > -1 
begin
   set @sql = @sql + ' and  RFU_Fru_ID = ' 
   set @sql = @sql + convert(varchar,@iFru)
   set @legacysql = @legacysql + ' and  RFU_Fru_ID = ' 
   set @legacysql = @legacysql + convert(varchar,@iFru)
end


if @iAction > - 1
begin
   set @sql = @sql + ' and RAN_RepairAction_ID = ' 
   set @sql = @sql +  convert(varchar,@iAction)
   set @legacysql = @legacysql + ' and RAN_RepairAction_ID = ' 
   set @legacysql = @legacysql +  convert(varchar,@iAction)
end


if @iOrigin > -1
begin
   set @sql = @sql + ' and  OCD_ID = '
   set @sql = @sql +   convert(varchar,@iOrigin)
   set @legacysql = @legacysql + ' and  OCD_ID = '
   set @legacysql = @legacysql +   convert(varchar,@iOrigin)
end


if len(@test) > 0
begin
   set @sql = @sql + ' and TST_TestName= ''' + @test + ''''
   set @legacysql = @legacysql + ' and FLG_Station like ''' + RTRIM(@test) + '%'''
end



if len(@line) > 0
begin
   set @sql = @sql + ' and  MfgLine.MLN_MfgLine = ''' + @line + ''''
     set @legacysql = @legacysql + '  and  MfgLine.MLN_MfgLine = ''' + @line + ''''

end



if len(@station) > 0
begin
   set @sql = @sql + ' and  FLG_Station= ''' + @station +''''
   set @legacysql = @legacysql +  ' and  FLG_Station= ''' + @station +''''
end


if @onlyuntouched = 1
begin
   set @sql = @sql + ' and FLG_touched= 0 '
   set @legacysql = @legacysql +  ' and FLG_touched= 0 '
end

--set @sql = @sql + ' ORDER BY FLG_FailureLogDate '
set @legacysql = @legacysql +  ' ORDER BY FLG_FailureLogDate '
print @sql

print 'legacyis'
print @legacysql

set @sql = @sql +'  UNION  ' + @legacysql
exec( @sql)
/*

select FLG_FailureLogDate,
 FLG_ORT, 
SAP_Model,
FLG_ACSSN,
FLG_Station,
FLG_Failure,
FLG_Critical, 
RFU_cFruCode, 
RFU_FruDescription,
RAN_ActCode, 
RAN_Description,
FLG_Comments,
OCD_cCode, 
OCD_Desc,
FLG_RootCauseComment, 
FLG_RootCauseOwner, 
FLG_PreventativeAction,
FLG_FL_ID, 
FLG_Touched,
FLG_Technician
from RawFruFailureLog
inner join testlog on RawFruFailureLog.FLG_TL_ID = TL_ID
inner join SAP_RepairFrus on FLG_Fru_ID = RFU_Fru_ID
inner join RepairAction on FLG_RepairAction_ID = RAN_RepairAction_ID
inner  join OriginCodes on FLG_OriginCode_ID = OCD_ID
WHERE FLG_FailureLogDate > @startDate
and FLG_FailureLogDate < @endDate
order by FLG_FailureLogDate
*/

select RFU_cFruCode, RFU_FruDescription
from SAP_NewRepairFrus
--where RFU_Type = @type
order by RFU_Order


select RAN_ActCode, RAN_Critical, RAN_Description
from RepairAction
--WHERE RAN_Type = @type



select CAC_Code, CAC_Description
from CauseCategory
--WHERE CAC_Type = @type


select OCD_cCode, OCD_Desc
from OriginCodes
--where OCD_Type = @type

/*

select RFU_cFruCode, RFU_FruDescription,
isnull(Fru_Category,'zznone') as testname,
RFU_Type,
isnull(Fru_Frequency,0)
from Fru_Frequency
right  outer join SAP_NewRepairFrus on Fru_Fru_ID = RFU_Fru_ID
order by Fru_Frequency desc, RFU_cFruCode

*/
select FALT_cFruCode, FALT_Description, FALT_Testname, FALT_Type, FALT_Frequency
from Fru_AllFreqTest
order by FALT_Frequency desc, FALT_Testname, FALT_cFruCode

select RAN_ActCode, RAN_Critical, RAN_Description, RAN_Type
from RepairAction


select OCD_cCode, OCD_Desc, OCD_Type
from OriginCodes
set @rvalue = 0




select distinct Station_Name, Description, Station_Count, TST_fInPCB
from Stations
inner join tests on Station_Name = STN_Name
order by Station_Name
GO