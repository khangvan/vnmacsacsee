SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getProdOrderInfo]
@serial char(20)
 AS
set nocount on

select TFFC_ProdOrder from TFFC_SerialNumbers where TFFC_SerialNumber=@serial
GO