SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_ffc_getmanualbackflush]
 AS
set nocount on

select Purchase_Order, Purchase_item, Material, Quantity, Serial_Number from ffc_manualbackflush
GO