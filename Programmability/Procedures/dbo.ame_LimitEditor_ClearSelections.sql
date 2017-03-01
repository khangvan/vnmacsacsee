SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_ClearSelections] 
@user char(50)
AS
set nocount on
delete from subtestlimitsselect where acsuser = @user
GO