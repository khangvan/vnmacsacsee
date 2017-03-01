SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getLimitStation_Note]
@station char(20)
as
set nocount on

select TTN_Note, TTN_NoteDate from TestTechNotes
where TTN_Station_Name = @station
GO