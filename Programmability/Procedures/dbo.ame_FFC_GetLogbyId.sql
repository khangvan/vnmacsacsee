SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_GetLogbyId]
@type int,
@id int 
AS
set nocount on
if @type = 1
begin
select Log_Response from FFC_Server_Log where LOG_ID = @id
end
else
begin
if @type = 2 
begin
select Log_Request from FFC_Log_Assigns where LOG_ID = @id
end
else
begin
select Log_Request from FFC_Log_ErrorAssigns where LOG_ID = @id
end
end
GO