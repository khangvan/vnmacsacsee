SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_Log_WriteAssignLog]
@Log_User varchar(50), 
@Log_URL varchar(50), 
@Log_Time datetime, 
@Log_RequestName text, 
@Log_Request text, 
@Log_Response text, 
@Log_ResponseTime datetime, 
@LOG_Status char(10), 
@LOG_Error varchar(50), 
@LOG_Notes varchar(50)
 AS
insert into FFC_Log_Assigns
(
Log_User, Log_URL, Log_Time, Log_RequestName, Log_Request, Log_Response, Log_ResponseTime, LOG_Status, LOG_Error, LOG_Notes
)
values
(
 @Log_User, 
@Log_URL, 
@Log_Time, 
@Log_RequestName, 
@Log_Request, 
@Log_Response, 
@Log_ResponseTime, 
@LOG_Status, 
@LOG_Error, 
@LOG_Notes
)
GO