SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_updateCOFOriginTable]
@id as int,
@country char(50),
@shortcountry char(2)
 AS
set nocount on


update COFOrigin set COF_Country = @country, COF_ShortCountry=@shortcountry where COF_ID = @id
GO