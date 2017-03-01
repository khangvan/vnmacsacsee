SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getCOFOriginTable] 
AS
set nocount on
select COF_ID,COF_PSC_ScannedSerial, COF_PSC_ScannedModel, COF_Country, COF_ShortCountry
from COFOrigin
order by COF_PSC_ScannedModel, COF_PSC_ScannedSerial
GO