SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_ClearEUGSubTestLimits]
as
set nocount on
truncate table FFC_EUG_SubTestLimits
GO