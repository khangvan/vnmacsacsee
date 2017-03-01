SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_get_OverrideAdd_parts]
 AS
select BOMA_Part, BOMO_Station, BOMO_Part, BOMO_Model, BOMO_Chars,BOMO_Notes, BOMO_User,
BOMA_PNotes, BOMA_PAuthor, BOMA_Expiration 
from BOM_PartAdds
inner join BOMOverrides_Parts on BOMA_OverrideID = BOMO_ID


set nocount on
GO