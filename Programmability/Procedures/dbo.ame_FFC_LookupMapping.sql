SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_LookupMapping]
@vendor char(10)
 AS
select EUGENE_StationName, PAN_StationName, PAN_StationType
from FFC_EUGPAN_MAPPING where Vendor_ID = @vendor
order by EUGENE_StationName
GO