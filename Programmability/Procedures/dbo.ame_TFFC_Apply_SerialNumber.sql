SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_Apply_SerialNumber]
@acsserial char(20),
@OK char(20)
 AS
set nocount on

declare @checkforserialinorder int
declare @reserved char(20)

select @checkforserialinorder = TFFC_ID from tffc_serialnumbers where TFFC_Reservedby = @acsserial

if @checkforserialinorder is not null
begin
   select @reserved = TFFC_ReservedBy from TFFC_Serialnumbers where TFFC_ID = @checkforserialinorder
   if @reserved is not null
   begin
         if len(rtrim(@reserved)) > 0 
         begin
                   update TFFC_SerialNumbers set TFFC_Consumed = 1 where TFFC_ID = @checkforserialinorder
                   set @OK ='OK'
          end
          else
          begin
             set @OK = 'BAD'
          end
   end
   else
   begin
      set @OK='BAD'
   end
end
else
begin
set @OK = 'Serial not found'
end

select @OK as ok
GO