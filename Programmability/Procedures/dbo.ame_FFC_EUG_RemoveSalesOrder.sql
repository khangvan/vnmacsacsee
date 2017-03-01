SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_EUG_RemoveSalesOrder]
@salesorder nvarchar(50),
@salesorderlineitem int
 AS
delete from  FFC_EUG_SalesOrders where FFC_SO_SalesOrder= @salesorder and FFC_SO_SalesItem = @salesorderlineitem
GO