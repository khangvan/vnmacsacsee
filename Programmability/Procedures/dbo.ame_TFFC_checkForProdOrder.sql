SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_checkForProdOrder]
@ProdOrder char(20),
@found char(20) OUTPUT,
@complete char(20) OUTPUT,
@PrintOnDemand char(2) = 'U' OUTPUT
 AS

set nocount on

set @PrintOnDemand='U'
set @complete = 'NO'
if exists 
(
select TFFC_Material from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder
)
begin
select @found=TFFC_Material from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder
select @PrintOnDemand  = TFFC_PrintOnDemand from TFFC_SerialNumbers where   TFFC_ProdOrder = @ProdOrder
if exists ( select TFFC_Material from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder and TFFC_Consumed = 0)
begin
set @complete = 'NO'
end
else
begin
set @complete= 'YES'
end
end
else
begin
set @found = 'NO'
end

select @found as found, @complete as completed, @PrintOnDemand as printondemand
GO