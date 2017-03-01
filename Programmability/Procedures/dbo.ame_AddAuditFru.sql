SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_AddAuditFru]
@sn char(20),
@sap char(20),
@station char(20),
@fruid int,
@detail char(80),
@comment char(80),
@ok int output
 AS
set nocount on


declare @tlid int


declare @repairaction int
declare @causecategory int
declare @origincode int


set @repairaction = 19
set @causecategory = 1
set @origincode  = 19


set @ok = 0
select @tlid = TL_ID from testlog where acs_serial = @sn and SAP_Model = @sap and Station = @station

if @tlid is not null
begin
     print 'adding fru'

insert into RawFruFailureLog
(
FLG_RepairAction_ID,
FLG_CauseCategory_ID,
FLG_OriginCode_ID,
FLG_Fru_ID,
FLG_ACSSN_ID,
FLG_TL_ID,
FLG_ACSSN,
FLG_Failure,
FLG_Station_ID,
FLG_Station,
FLG_RootCauseComment,
FLG_RootCauseOwner,
FLG_Critical,
FLG_ORT,
FLG_Technician,
FLG_PreventativeAction,
FLG_Comments,
FLG_FailureLogDate,
FLG_DateGrouping_ID,
FLG_Type,
FLG_Touched,
FLG_ReportType,
FLG_Generated,
FLG_LastModified
)
values
(
@repairaction,
@causecategory,
@origincode,
@fruid,
0,
@tlid,
@sn,
@detail,
0,
@station,
'',
'',
0,
0,
'',
'',
@comment,
getdate(),
0,
1,
0,
0,
0,
getdate()
)

end
else
begin
set @ok = 1
end
GO