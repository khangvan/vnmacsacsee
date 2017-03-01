SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LookupLegacyRecord] 
@sn char(20) AS
set nocount on


select * from LegacyFruFailureLog where FLG_ACSSN = @sn

GO