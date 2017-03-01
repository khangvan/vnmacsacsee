SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ame_TFFC_getProdOrderPrintProcess]
@prodorder char(20),
@printtype char(2) OUTPUT, 
@result char(20) OUTPUT
 AS
set nocount on


--if  ( select count(*) from tffc_serialnumbers where TFFC_prodorder = @prodorder ) > 0 
if exists ( select TOP 1 tffc_serialnumber from tffc_serialnumbers where TFFC_prodorder = @prodorder )
begin
   --select @printtype = TFFC_PrintOnDemand from tffc_serialnumbers  where TFFC_prodorder = @prodorder
   select TOP 1 @printtype = TFFC_PrintOnDemand from tffc_serialnumbers  where TFFC_prodorder = @prodorder order by tffc_id
   set @result = 'OK'
end
else
begin
   set @printtype = ''
   set @result = 'NOTFOUND'
end

select @result as result, @printtype as printtype
GO