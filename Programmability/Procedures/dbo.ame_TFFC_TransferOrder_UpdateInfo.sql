SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_TFFC_TransferOrder_UpdateInfo]
@to char(10),
@material char(20),
@count int
 AS
set nocount on

declare @toid int


select @toid = TransferOrder_ID from TFFC_TransferOrders where TransferOrder_OrderNum = @to and TransferOrder_material = @material

update TFFC_TransferOrders set TransferOrder_CurrentCount = @count where TransferOrder_ID = @toid
GO