SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_UpdateLegacyFailureLog] 
@flgflid int,
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
@iOK int OUTPUT
AS
declare @curdate datetime

set @curdate = getdate()

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
FLG_RepairAction_ID = (select RAN_RepairAction_ID from RepairAction where RAN_ActCode = @ActCode and RAN_Type =@type),
FLG_Fru_ID = ( select RFU_Fru_ID from SAP_NewRepairFrus where RFU_cFruCode = @FruCode and RFU_Type=@type ),
FLG_OriginCode_ID = (select OCD_ID from OriginCodes where OCD_cCode = @CauseCode and OCD_Type = @type),
FLG_LastModified = @curdate
where  FLG_FL_ID = @flgflid

set @iOK = 0
GO