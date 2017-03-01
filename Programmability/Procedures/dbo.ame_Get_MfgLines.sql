SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_Get_MfgLines] AS
set nocount on

select MLN_MfgLine_ID,
MLN_MfgLine
from MfgLine
GO