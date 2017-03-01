SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getSalesOrders]

AS
set nocount on

  select Col001 from sorders
GO