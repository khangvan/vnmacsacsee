SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_Remove_OverridePartDeletes]
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

   if  exists ( select BOMP_ID from BOMOVerrides_PartDeletes where BOMP_OverrideID = @modelid and BOMP_Part = @part)
   begin


       insert into BOMOverrides_Log
       (
           BOMP_ID, 
           BOMP_OverrideID, 
           BOMP_Part, 
           BOMP_Expiration, 
           BOMP_PNotes, 
           BOMP_PAuthor, 
           BOMP_InsertDate, 
           BOMP_ActionDate, 
           BOMP_Action,
           BOMP_ActionUser
        )
        select BOMP_ID, BOMP_OverrideID, BOMP_Part, BOMP_Expiration, BOMP_PNotes, BOMP_PAuthor,
                  BOMP_InsertDate, getdate(),'Removed', @user from BOMOverrides_PartDeletes where BOMP_OverrideID = @modelid and BOMP_Part = @part


       delete from BOMOverrides_PartDeletes where BOMP_OverrideID = @modelid and BOMP_Part = @part
   end

end
GO