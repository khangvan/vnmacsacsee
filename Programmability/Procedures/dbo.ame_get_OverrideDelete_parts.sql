SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_get_OverrideDelete_parts]
 AS
select BOMP_Part, BOMO_Station, BOMO_Part, BOMO_Model, BOMO_Chars, 
BOMO_Notes, BOMO_User, 
BOMP_PNotes, BOMP_PAuthor,BOMP_Expiration 
from BOMOverrides_PartDeletes
inner join BOMOverrides_Parts on BOMP_OverrideID = BOMO_ID


set nocount on
GO