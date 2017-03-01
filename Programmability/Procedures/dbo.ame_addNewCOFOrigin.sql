SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_addNewCOFOrigin]
@scannedserial char(10),
@model char(10),
@country varchar(50),
@shortcountry varchar(2) 
AS
set nocount on


if exists
(
select COF_ID from COFOrigin
where substring(@scannedserial,1,len(COFOrigin.COF_PSC_ScannedSerial)) = COFOrigin.COF_PSC_ScannedSerial
and substring(@model,1,len(COFOrigin.COF_PSC_ScannedModel)) = COFOrigin.COF_PSC_ScannedModel
)
begin

print 'Ah Ah Ah!!!!! NOOOOOOO! '
print 'combination already exists'
end
else
begin
insert into  COFOrigin
(
COF_PSC_ScannedSerial, 
COF_PSC_ScannedModel,  
COF_Country, 
COF_ShortCountry
)
values
(
rtrim(@scannedserial),
rtrim(@model),
rtrim(@country),
rtrim(@shortcountry)
)

print 'added OK'
end
GO