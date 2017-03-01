SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_GetSAPSRCList] 
AS
set nocount on

select Vendor, Plant, DaysForward
from FFC_SAPSRCLIST
GO