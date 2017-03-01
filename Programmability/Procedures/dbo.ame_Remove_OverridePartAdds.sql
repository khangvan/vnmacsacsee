SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_Remove_OverridePartAdds]
@station char(20),
@model char(20),
@nchars int,
@part char(20),
@user char(50),
@ret int OUTPUT

 AS
set nocount on



declare @modelid int



declare @bomoid int


set @ret = 0 

if  exists ( select BOMO_ID from BOMOverrides_Parts where BOMO_Station = @station and substring(BOMO_model,1,@nchars) = substring(@model,1,@nchars))
begin
 select @modelid =  BOMO_ID from BOMOverrides_Parts where BOMO_Station = @station and substring(BOMO_model,1,@nchars) = substring(@model,1,@nchars)

   if  exists ( select BOMP_ID from BOMOVerrides_PartAdds where BOMA_OverrideID = @modelid and BOMA_Part = @part)
   begin
       delete from BOMOverrides_PartAdds where BOMA_OverrideID = @modelid and BOMA_Part = @part
   end

end
GO