SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[AMENET_GetPrintModelFieldValues] 
@model char(20),
@culture char(10)
AS
set nocount on

select NACS_Field_Name, NACS_Field_Description,
x.NACS_PrintModel_ID, x.NACS_PrintModel_Name, x.NACS_PrintField_ID,
x.NACS_PrintValue
from NACS_PrintFields
left outer join
(
select NACS_PrintModels.NACS_PrintModel_ID, NACS_PrintModel_Name,
NACS_PrintField_ID, NACS_PrintValue
from NACS_PrintModelField
inner join NACS_PrintModels on NACS_PrintModels.NACS_PrintModel_ID = NACS_PrintModelField.NACS_PrintModel_ID
inner join NACS_Cultures on NACS_PrintModelField.NACS_Culture_ID = NACS_Cultures.NACS_Culture_ID
where NACS_PrintModel_Name=@model
and NACS_Cultures.NACS_Culture = @culture
) x on NACS_Field_ID = x.NACS_PrintField_ID
order by NACS_Field_Name
GO