SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_LookupModelsClear]
 AS
truncate table FFC_LookupModels
GO