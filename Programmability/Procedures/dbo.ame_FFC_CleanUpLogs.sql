SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_CleanUpLogs]
@daysback int
 AS
set nocount on

declare @today datetime
declare @timeago datetime
set @today = getdate() 

set @timeago = DateAdd(dd,-@daysback,@today)

delete from FFC_BackFlush_Log where Log_Time < @timeago

delete from FFC_Server_log where Log_Time < @timeago

GO