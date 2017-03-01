SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[AMENET_AddPrintModel]
@model char(20)
 AS
set nocount on

declare @trimmedmodel char(20)

set @trimmedmodel = ltrim(@model)
set @trimmedmodel = rtrim(@trimmedmodel)

if ( not exists ( select  NACS_PrintModel_ID from NACS_PrintModels where NACS_PrintModel_Name = @trimmedmodel ))
begin
insert into NACS_PrintModels
(
NACS_PrintModel_Name
)
values
(
@trimmedmodel
)

select 'OK'
end
else -- model already in table
begin
select 'Model Already Exists!'
end
GO