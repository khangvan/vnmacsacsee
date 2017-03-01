SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ame_UpdateOldDB1] AS
declare @lastmaxtlid int
declare @lastmaxstlid int
declare @lastmaxassid int
declare @lastmaxasslogid int
declare @lastmaxcatcount int
declare @maxtlid int
declare @maxstlid int
declare @maxassid int
declare @maxasslogid int
declare @maxcatcount int

select @lastmaxtlid = maxTLID from lastUpdateIDs
select @maxtlid = max(TL_ID) from testlog

insert into [ACSEEDB1].[ACS EE].dbo.[testlog]
(
ACS_Serial,
SAP_Model,
Station,
Test_ID,
Pass_Fail,
FirstRun,
Test_Date_Time,
ACSEEMode
)
select
ACS_Serial,
SAP_Model,
Station,
Test_ID,
Pass_Fail,
FirstRun,
Test_Date_Time,
ACSEEMode
FROM
testlog
where
TL_ID > @lastmaxtlid AND TL_ID <= @maxtlid
order by TL_ID



update lastUpdateIDs set maxTLID = @maxtlid






select @lastmaxstlid = maxSTLID from lastUpdateIDs

select @maxstlid = max(STL_ID) from subtestlog

insert into [ACSEEDB1].[ACS EE].dbo.[subtestlog]
(
ACS_Serial,
Station,
Subtest_Name,
Test_ID,
Pass_Fail,
strValue,
intValue,
floatValue,
Units,
Comment
)
select
ACS_Serial,
Station,
Subtest_Name,
Test_ID,
Pass_Fail,
strValue,
intValue,
floatValue,
Units,
Comment
FROM
subtestlog
where STL_ID > @lastmaxstlid AND STL_ID <= @maxstlid
order by STL_ID



update lastUpdateIds set MAXSTLID = @maxstlid






select @lastmaxassid = MAXASSID  from lastUpdateIDs

select @maxassid = MAX(assem_id) from assemblies

insert into [ACSEEDB1].[ACS EE].dbo.[Assemblies]
(
ACS_Serial,
SAP_Model_No,
Start_Station,
Top_Model_Prfx,
Start_Mfg,
PSC_Serial,
End_Mfg,
Sales_Order,
Line_Item,
Current_State
)
select
ACS_Serial,
SAP_Model_No,
Start_Station,
Top_Model_Prfx,
Start_Mfg,
PSC_Serial,
End_Mfg,
Sales_Order,
Line_Item,
Current_State
FROM assemblies
where assem_id > @lastmaxassid and assem_id <= @maxassid
and ACS_Serial not in
(select ACS_Serial from [ACSEEDB1].[ACS EE].dbo.[Assemblies] )
order by assem_id



update lastUpdateIds set MAXASSID = @maxassid



select @lastmaxcatcount =  MAXCATCOUNT from lastUpdateIDs

select @maxcatcount = MAX(part_no_count) from Catalog

insert into [ACSEEDB1].[ACS EE].dbo.[Catalog]
(
Part_No_Count,
Part_no_Name,
Description,
Status,
FactoryGroup_Mask,
ProductGroup_Mask
)
select
Part_No_Count,
Part_no_Name,
Description,
Status,
FactoryGroup_Mask,
ProductGroup_Mask
from catalog
where part_no_count > @lastmaxcatcount and part_no_count <= @maxcatcount


update lastUpdateIds set MAXCATCOUNT = @maxcatcount





select @lastmaxasslogid = MAXASSLOGID from lastUpdateIDs

select @maxasslogid = max(asylog_ID) from asylog

insert into [ACSEEDB1].[ACS EE].dbo.[asylog]
(
ACS_Serial,
Station,
Action,
Added_Part_No,
Scanned_Serial,
Rev,
Action_Date,
Quantity
)
select
ACS_Serial,
Station,
Action,
Added_Part_No,
Scanned_Serial,
Rev,
Action_Date,
Quantity
FROM asylog
where asylog_id > @lastmaxasslogid and asylog_id <= @maxasslogid
order by asylog_id



update lastUpdateIDs set maxasslogid = @maxasslogid




insert into [ACSEEDB1].[ACS EE].dbo.[Products]
(
SAP_Count,
SAP_Model_Name,
Format_Name,
Status
)
select
SAP_Count,
SAP_Model_Name,
Format_Name,
Status
from Products where
SAP_Count not in
(
select SAP_Count from [ACSEEDB1].[ACS EE].dbo.[Products]
)
GO