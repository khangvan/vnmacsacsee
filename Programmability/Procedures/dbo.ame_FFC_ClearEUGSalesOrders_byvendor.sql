SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_ClearEUGSalesOrders_byvendor]
@Vendor char(20) ='104341',
@Plant char(10) ='1000'
as
set nocount on
delete from dbo.FFC_EUG_SalesOrders where FFC_SO_Vendor = @Vendor and FFC_SO_Plant = @Plant
GO