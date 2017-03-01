SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_GetProdOrderInfo]
@model char(20),
@acsserial char(20),
@prodorder char(20) OUTPUT,
@printtype char(20) OUTPUT
 AS
set nocount on

declare @foundProdOrder char(20)

select @foundProdOrder = ProdOrder from [ACSEEState].[dbo].loci where sap_model = @model and acs_serial = @acsserial

if @foundProdOrder is not null and len(rtrim(@foundProdOrder)) > 0 
begin
   select @printtype = TFFC_PrintOnDemand, @prodorder = TFFC_ProdOrder  from TFFC_Serialnumbers where TFFC_ProdOrder = @foundProdOrder
end
else
   begin
      set @prodorder = 'NONE'
      set @printtype = 'NA'
   end

select @prodorder as ProductionOrder, @printtype as PrintType
GO