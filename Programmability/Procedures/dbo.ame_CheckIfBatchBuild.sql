SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_CheckIfBatchBuild]
@station char(30),
@model char(30)
 AS
set nocount on

declare @enableBatchMode int
declare @defaultToBatch int 
declare @stationmodelbatchindicator int
declare @batchcomment char(80)


select @enableBatchMode = isnull(EnableBatchMode,0) from stations where station_name = rtrim(@station)

if @enableBatchMode = 1 
begin
   select @defaultToBatch = isnull(DefaultToBatchMode,0) from stations where station_name = rtrim(@station)
   
   select @stationmodelbatchindicator = isnull(BatchBuild_BatchorNotIndicator,0),
              @batchcomment = isnull(BatchBuild_Comment,'') from BatchBuilds where BatchBuild_StationName = rtrim(@station) and BatchBuild_ModelName=rtrim(@model)   

    select @stationmodelbatchindicator as BatchMode 
end
else
begin
 select 0 as BatchMode
end
GO