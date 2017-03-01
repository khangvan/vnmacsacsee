SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_Set_Units_SerialNumber]
@acsserial char(20),
@prodorder char(20),
@pscserial char(20),
@OK char(20) OUTPUT
 AS
set nocount on

declare @checkforserialinorder int
declare @reserved char(20)

select @checkforserialinorder = TFFC_ID from tffc_serialnumbers where TFFC_ProdOrder = @prodorder and TFFC_SerialNumber = @pscserial

if @checkforserialinorder is not null
begin
   select @reserved = TFFC_ReservedBy from TFFC_Serialnumbers where TFFC_ID = @checkforserialinorder
   if @reserved is not null
   begin
         if len(rtrim(@reserved)) > 0 
         begin
                   set @OK ='Serial Not empty'
          end
   end
   else
   begin
       update TFFC_Serialnumbers set TFFC_Reservedby = @pscserial , TFFC_Reserved = 1 ,  TFFC_ReservedTime = getdate() where TFFC_ID = @checkforserialinorder
      set @OK='OK'
   end
end
else
begin
set @OK = 'Serial not found'
end

select @OK as ok
GO