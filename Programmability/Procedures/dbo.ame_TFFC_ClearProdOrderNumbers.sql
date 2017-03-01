SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_ClearProdOrderNumbers]
@ProdOrder nchar(20)
 AS

set nocount on


delete from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder
GO