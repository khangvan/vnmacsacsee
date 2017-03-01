SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_Add_OverridePartDeletes]
@station char(20),
@model char(20),
@nchars int,
@part char(20),
@notes char(50),
@user char(50),
@expiredate datetime,
@ret int OUTPUT

 AS
set nocount on



declare @modelid int



declare @bomoid int


set @ret = 0 

if not exists ( select BOMO_ID from BOMOverrides_Parts where BOMO_Station = @station and substring(BOMO_model,1,@nchars) = substring(@model,1,@nchars))
begin
insert into BOMOverrides_Parts
(
BOMO_Station,
BOMO_Model,
BOMO_Chars,
BOMO_Part,
BOMO_Notes,
BOMO_user
)
values
(
@station,
@model,
@nchars,
@part,
@notes,
@user
)


              set @modelid = scope_identity()


end
else
begin
select @modelid =  BOMO_ID from BOMOverrides_Parts where BOMO_Station = @station and substring(BOMO_model,1,@nchars) = substring(@model,1,@nchars)
end




if @modelid is not null
begin

   insert into BOMOVerrides_PartDeletes
   (
   BOMP_OverrideID,
  BOMP_Part,
   BOMP_PNotes,
   BOMP_PAuthor,
   BOMP_Expiration,
   BOMP_InsertDate
   )
  values
   (
      @modelid,
      @part,
      @notes,
      @user,
      @expiredate,
      getdate()
   )
end
GO