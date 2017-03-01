SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_InsertCOFOrigin]
@COF_ID int, 
@COF_PSC_ScannedSerial char(10), 
@COF_PSC_ScannedModel char(10), 
@COF_ACS_ScannedSerial char(10), 
@COF_PartNumber char(10), 
@COF_Country char(10), 
@COF_ShortCountry char(2)
 AS
insert into FFC_COFOrigin
(
COF_ID,
COF_PSC_ScannedSerial, 
COF_PSC_ScannedModel, 
COF_ACS_ScannedSerial, 
COF_PartNumber, 
COF_Country, 
COF_ShortCountry
)
values
(
@COF_ID,
@COF_PSC_ScannedSerial, 
@COF_PSC_ScannedModel, 
@COF_ACS_ScannedSerial, 
@COF_PartNumber, 
@COF_Country, 
@COF_ShortCountry
)
GO