SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_Stage_ClearLimits]
@username char(50)
AS
set nocount on


delete from Stage_SubtestLimits where TableUser = @username
--truncate table Stage_Subtestlimits
GO