SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_SubAssemblyPathClear]
@user char(50)
 AS
delete  from  SubAssemblyPathLookup where user_id = @user
GO