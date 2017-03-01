SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_GetLogInfo]
@type int
AS
set nocount on
if @type = 1
begin
select Log_ID, Log_User, Log_Time,Log_ResponseTime from FFC_Server_Log 
end
else
begin
if @type = 2
begin
select Log_ID, Log_User, Log_Time,Log_ResponseTime from FFC_Log_Assigns 
end
else
begin
select Log_ID, Log_User, Log_Time,Log_ResponseTime from FFC_Log_ErrorAssigns 
end
end
GO