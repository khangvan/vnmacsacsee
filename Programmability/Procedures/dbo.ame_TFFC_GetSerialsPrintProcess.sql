SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_GetSerialsPrintProcess]
@acsserial char(20),
@Result char(20) OUTPUT
AS

declare @tffcid int
declare @prodorder char(20)

select @prodorder = Prodorder from [ACSEEState].[dbo].loci where acs_serial = @acsserial
if @prodorder is not null
begin
   if len(rtrim(@prodorder)) > 0
   begin
      select @Result = TFFC_PrintOnDemand from TFFC_SerialNumbers where TFFC_ProdOrder = @prodorder
    end
   else
   begin
        set @Result = 'BAD'
   end
end
else
begin
  set @Result = 'BAD'
end


select @Result as result
GO