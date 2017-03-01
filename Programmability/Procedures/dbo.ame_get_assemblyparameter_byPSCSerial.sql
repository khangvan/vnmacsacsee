SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_get_assemblyparameter_byPSCSerial]
@pscserial char(20),
@itemkey char(20)
 AS

set nocount on

declare @assemid int

select @assemid = assem_ID from assemblies where psc_serial = @pscserial


if @assemid is not null
begin

select ASP_Key, ASP_Value, asp_type from assemblyparameters where asp_assem_id = @assemid and asp_key = @itemkey
end
else
begin
select 'NONE','NONE','NONE'
end
GO