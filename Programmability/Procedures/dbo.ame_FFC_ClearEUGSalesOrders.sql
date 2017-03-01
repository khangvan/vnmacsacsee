SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_ClearEUGSalesOrders]
as
set nocount on
truncate table dbo.FFC_EUG_SalesOrders
GO