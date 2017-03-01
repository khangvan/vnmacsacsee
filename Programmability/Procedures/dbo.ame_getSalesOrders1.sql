SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getSalesOrders1]

AS
set nocount on

  select Col001 from sorders1
GO