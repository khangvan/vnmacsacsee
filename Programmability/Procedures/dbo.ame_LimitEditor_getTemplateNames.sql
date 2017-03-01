SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_getTemplateNames]
 AS
set nocount on
select distinct set_name from subtesttemplates
order by set_name
GO