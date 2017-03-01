SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_GetPanEugMapping]
AS
set nocount on
select EUGENE_STATIONName,
EUGENE_Station_Count,
PAN_StationName,
PAN_StationType,
PAN_Station_Count,
Vendor_ID
from FFC_EUGPAN_MAPPING
GO