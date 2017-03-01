SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_Add_AssemblyParameter]
@acsserial char(20),
@keyvalue char(20),
@itemvalue char(20),
@itemtype char(20)
AS

set nocount on

declare @assemid int


select @assemid = assem_ID from assemblies where acs_serial = @acsserial

if @assemid is not null 
begin
if exists ( select ASP_ID from assemblyparameters where ASP_Assem_ID = @assemid and asp_key = @keyvalue )
begin
update assemblyparameters set asp_value = @itemvalue, asp_type = @itemtype where ASP_Assem_ID = @assemid and asp_key = @keyvalue
end
else
begin
insert into assemblyparameters ( ASP_Assem_ID, asp_key, asp_value, asp_type )
values
(
@assemid,
@keyvalue,
@itemvalue,
@itemtype
)
end
select 'OK'
end
else
begin
select 'NOSERIALFOUND'
end
GO