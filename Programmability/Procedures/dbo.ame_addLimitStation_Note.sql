SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_addLimitStation_Note] 
@station char(20),
@note varchar(2000),
@retcode int OUTPUT
AS
set nocount on

set @retcode = 0

delete from TestTechNotes
where TTN_Station_Name = @station

insert into TestTechNotes
(
TTN_Station_Name,
TTN_Note,
TTN_NoteDate
)
values
(
@station,
@note,
getdate()
)

if @@ERROR <>0
begin
  set @retcode = 1
end
GO