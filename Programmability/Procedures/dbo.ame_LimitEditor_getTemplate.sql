SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_getTemplate]
@name char(50)
 AS
set nocount on
select * from subtesttemplates where set_name = @name
GO