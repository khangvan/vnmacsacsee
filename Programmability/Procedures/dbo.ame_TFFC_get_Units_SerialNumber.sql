SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_get_Units_SerialNumber] 
@acsserial char(20),
@pscserial char(20) OUTPUT,
@OK char(20) OUTPUT
AS
set nocount on


set @OK = 'BAD'

select @pscserial = TFFC_SerialNumber from TFFC_SerialNumbers where TFFC_Reservedby= @acsserial

if @pscserial is not null
begin
   set @OK = 'OK'
end


select @OK as OK, @pscserial as pscserial
GO