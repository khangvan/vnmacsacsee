SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[AMENET_SavePrintModelFieldValues]
@model char(20),
@culture char(10),
@fieldname char(50),
@fielddescription char(80),
@fieldvalue char(50)
 AS
set nocount on

declare @modelid int
declare @printfieldid int
declare @cultureid int
declare @printmodelfieldid int

if  not exists ( select  NACS_PrintModel_ID from NACS_PrintModels where NACS_PrintModel_name=@model )
begin
SELECT 'Model Not Found'
return

end
select @modelid = NACS_PrintModel_ID from NACS_PrintModels where NACS_PrintModel_name=@model


if not exists ( select  NACS_Culture_ID from NACs_Cultures where NACS_Culture = @culture )
begin
SELECT 'Culture Not Found'
return
end
select @cultureid = NACS_Culture_ID from NACs_Cultures where NACS_Culture = @culture

if not exists (select  NACS_Field_ID from NACS_PrintFields where NACS_Field_Name = @fieldname )
begin
select 'Field Name Not Found'
return
end
select @printfieldid = NACS_Field_ID from NACS_PrintFields where NACS_Field_Name = @fieldname 

update NACS_PrintFields
set NACS_Field_Description = @fielddescription where NACS_Field_ID = @printfieldid



if exists ( select NACS_PrintModelField_ID from NACS_PrintModelField where NACS_PrintModel_ID = @modelid and NACS_PrintField_ID = @printfieldid and NACS_Culture_ID = @cultureid )
begin

select @printmodelfieldid = NACS_PrintModelField_ID from NACS_PrintModelField where NACS_PrintModel_ID = @modelid and NACS_PrintField_ID = @printfieldid and NACS_Culture_ID = @cultureid

if len(rtrim(@fieldvalue)) > 0
begin
update NACS_PrintModelField set NACS_PrintValue = @fieldvalue where NACS_PrintModelField_ID = @printmodelfieldid
end
else
begin
delete from NACS_PrintModelField where NACS_PrintModelField_ID = @printmodelfieldid
end
end
else
begin

if len(rtrim(@fieldvalue)) > 0
begin
insert into NACS_PrintModelField
(
NACS_PrintModel_ID,
NACS_PrintField_ID,
NACS_Culture_ID,
NACS_PrintValue
)
values
(
@modelid,
@printfieldid,
@cultureid,
@fieldvalue
)
end
end

select 'OK'
GO