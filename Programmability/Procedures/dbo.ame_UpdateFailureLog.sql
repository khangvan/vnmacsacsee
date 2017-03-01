SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_UpdateFailureLog] 
@flgflid int,
@serial varchar(20),
@ORT varchar(2),
@failure varchar(80),
@Critical tinyint,
@FruCode varchar(80),
@FruDescription varchar(80),
@ActCode int,
@ActDescription varchar(80),
@Comments char(80),
@CauseCode varchar(80),
@CauseDesc varchar(80),
@RootCauseComment varchar(80),
@RootCauseOwner varchar(80),
@PreventativeAction varchar(80),
@flgTouched tinyint,
@Technician varchar(10),

@type int,
@station varchar(20),
@iOK int OUTPUT
AS
declare @curdate datetime
declare @frucount int
declare @fruid int
declare @originid int
declare @actionid int
/* declare @station varchar(20) */

select @actionid = RAN_RepairAction_ID from RepairAction where RAN_ActCode = @ActCode and RAN_Type =@type

select @fruid = RFU_Fru_ID from SAP_NewRepairFrus where RFU_cFruCode = @FruCode and RFU_Type=@type

select @originid =  OCD_ID from OriginCodes where OCD_cCode = @CauseCode and OCD_Type = @type

if @fruid is null
begin
set @fruid = 1
end

if @actionid is null
begin
set @actionid = 19
end

if @originid is null
begin
set @originid = 1
end

select @frucount =  count(*)  from RawFruFailureLog where FLG_FL_ID = @flgflid and FLG_ACSSN = @serial

set @curdate = getdate()


if @frucount > 0
begin
update RawFruFailureLog
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
FLG_RepairAction_ID = @actionid,
FLG_Fru_ID = @fruid,
FLG_OriginCode_ID = @originid,
FLG_LastModified = @curdate
where  FLG_FL_ID = @flgflid
end
else
begin
update LegacyFruFailureLog
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
FLG_RepairAction_ID = @actionid,
FLG_Fru_ID = @fruid,
FLG_OriginCode_ID = @originid,
FLG_LastModified = @curdate,
FLG_Station=@station
where  FLG_FL_ID = @flgflid
end

set @iOK = 0
GO