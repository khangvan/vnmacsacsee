SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_CreateNewFailureLog] 
@ORT varchar(2),
@failure varchar(80),
@Critical tinyint,
@FruCode varchar(80),
@ActCode int,
@Comments char(80),
@CauseCode varchar(80),
@RootCauseComment varchar(80),
@RootCauseOwner varchar(80),
@PreventativeAction varchar(80),
@flgTouched tinyint,
@Technician varchar(10),
@type int,
@station char(20),
@model char(20),
@sn char(20),
@iOK int OUTPUT
AS
set nocount on

declare @curdate datetime
declare @actionid int
declare @causeid int
declare @originid int
declare @fruid int
declare @snid int
declare @tlid int
declare @stationid int
declare @dateid int

select @actionid = RAN_RepairAction_ID from RepairAction where RAN_ActCode = @ActCode and RAN_Type =@type

select @fruid = RFU_Fru_ID from SAP_NewRepairFrus where RFU_cFruCode = @FruCode and RFU_Type=@type

select @originid =  OCD_ID from OriginCodes where OCD_cCode = @CauseCode and OCD_Type = @type

if @fruid is null
begin
set @fruid = 1
end

if @actionid is null
begin
set @actionid = 1
end

if @originid is null
begin
set @originid = 1
end




set @curdate = getdate()

insert  LegacyFruFailureLog
(
FLG_RepairAction_ID,
FLG_CauseCategory_ID,
FLG_OriginCode_ID,
FLG_Fru_ID,
FLG_ACSSN_ID,
FLG_TL_ID,
FLG_ACSSN,
FLG_Model,
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
@actionid,
0,
@originid,
@fruid,
0,
0,
@sn,
@model,
@failure,
0,
@station,
@rootcausecomment,
@rootcauseowner,
@critical,
@ORT,
@technician,
@preventativeaction,
@comments,
@curdate,
0,
@type,
1,
1,
0,
@curdate
)
/*
set
FLG_ORT = @ORT,
FLG_Failure = @failure,
FLG_Critical = @Critical,
FLG_Comments = @Comments,
FLG_RootCauseComment = @RootCauseComment,
FLG_RootCauseOwner = @RootCauseOwner,
FLG_PreventativeAction = @PreventativeAction,
FLG_Touched = @flgTouched,
FLG_Technician = @Technician,
FLG_RepairAction_ID = (select RAN_RepairAction_ID from RepairAction where RAN_ActCode = @ActCode and RAN_Type =@type),
FLG_Fru_ID = ( select RFU_Fru_ID from SAP_NewRepairFrus where RFU_cFruCode = @FruCode and RFU_Type=@type ),
FLG_OriginCode_ID = (select OCD_ID from OriginCodes where OCD_cCode = @CauseCode and OCD_Type = @type),
FLG_LastModified = @curdate
where  FLG_FL_ID = @flgflid
*/
set @iOK = 0
GO