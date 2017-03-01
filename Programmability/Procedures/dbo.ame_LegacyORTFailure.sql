SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LegacyORTFailure] 
@sn char(20) ,
@failure char(80),
@comments char(80)
 AS

set nocount on


update LegacyORTLog
set FLG_Failed = 1, 
FLG_Failure=@failure,
FLG_Comments = @comments
where FLG_ACSSN = @sn
GO