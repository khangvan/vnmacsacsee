SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_BAK_ClearTables]
 AS
set nocount on

truncate table FFC_BAK_Catalog
truncate table FFC_BAK_SalesOrders
truncate table FFC_BAK_Serials
GO