SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_clearTemplate]
@name char(50)
 AS
set nocount on
delete from subtesttemplates where Set_Name = @name
GO