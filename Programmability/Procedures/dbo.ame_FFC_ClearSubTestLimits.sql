SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_ClearSubTestLimits]
as
set nocount on
truncate table FFC_SubTestLimits
GO