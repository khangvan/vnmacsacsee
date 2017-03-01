SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_cleanupSubtestFailures] AS


declare @laststfid int


select @laststfid = max(STF_ID) from subtestfailures



delete from subtestfailures where STF_ID < ( @laststfid - 10000)
GO