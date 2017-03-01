SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_PERBOM_getUniqueModels]
 AS
set nocount on
select distinct PERFOMPArtlist_model
from PERBOMPartList
GO