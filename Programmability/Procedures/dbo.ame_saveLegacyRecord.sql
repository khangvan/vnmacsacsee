SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_saveLegacyRecord] 
@sn char(80),
@actionid int,
@originid int,
@fruid int,
@failure char(80),
@station char(80),
@rootcausecomment varchar(80),
@rootcauseowner varchar(80),
@critical int,
@ort char(10),
@technician varchar(80),
@preventative varchar(80),
@comments varchar(80),
@rvalue int  output
AS
set nocount on


declare @acssnid int
declare @dateid int
declare @stationid int


select @stationid = station_count from Stations where Station_Name = @station


insert into LegacyFruFailureLog
(
FLG_RepairAction_ID,
FLG_OriginCode_ID,
FLG_Fru_ID,
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
FLG_LastModified
)
values
(
@actionid,
@originid,
@fruid,
@failure,
@stationid,
@station,
@rootcausecomment,
@rootcauseowner,
@critical,
@ort,
@technician,
@preventative,
@comments,
getdate(),
@dateid,
getdate()
)


set @rvalue = 0
GO