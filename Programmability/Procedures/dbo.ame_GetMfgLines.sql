SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_GetMfgLines] 
AS
set nocount on

select
MLN_MfgLine_ID,
MLN_MfgLine,
MLN_Location
from MfgLine
order by MLN_MfgLine_ID

GO