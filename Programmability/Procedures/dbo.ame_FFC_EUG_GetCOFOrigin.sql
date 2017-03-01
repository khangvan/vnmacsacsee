SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_EUG_GetCOFOrigin] 
AS
select
COF_ID, 
COF_PSC_ScannedSerial, 
COF_PSC_ScannedModel, 
COF_ACS_ScannedSerial, 
COF_PartNumber, 
COF_Country, 
COF_ShortCountry
from COFOrigin


GO