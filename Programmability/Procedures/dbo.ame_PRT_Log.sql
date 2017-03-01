SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_PRT_Log] 
@user varchar(100),
@machine varchar(100),
@time datetime,
@location varchar(100),
@message varchar(100),
@adjunct varchar(100),
@status varchar(10),
@Notes varchar(100)

 AS

insert into PRT_Log
(
 Log_User, 
Log_Machine, 
Log_Time, 
Log_Location, 
Log_Message, 
Log_AdjunctMessage, 
LOG_Status,
 LOG_Notes,
 LOG_DBTime
)
values
(
@user ,
@machine ,
@time ,
@location ,
@message ,
@adjunct ,
@status ,
@Notes ,
getdate()
)
GO