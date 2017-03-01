SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_setProdOrderPrintProcess]
@prodorder char(20),
@printtype char(2),
@result char(20) OUTPUT
 AS
set nocount on

if not exists ( select TFFC_ID from tffc_serialnumbers where tffc_prodorder = @prodorder)
begin
   set @result ='NOTFOUND'
end
else
begin
   update tffc_serialnumbers set tffc_printondemand = @printtype where tffc_prodorder = @prodorder
   set @result='OK'
end

select @result as result, @printtype as printtype
GO