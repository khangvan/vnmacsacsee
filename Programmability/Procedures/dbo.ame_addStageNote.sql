SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_addStageNote]
@user char(50),
@note char(2000)
 AS
set nocount on

delete from Stage_Notes
where StageNote_User = @user


insert into Stage_Notes
(
StageNote_User,
StageNote_Note
)
values
(
@user,
@note
)
GO