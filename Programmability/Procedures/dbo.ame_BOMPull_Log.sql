SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_BOMPull_Log]
@message char(512)
 AS
set nocount on
insert into BOMPull_Log
(
BOMPull_Log_text,
BOMPull_Log_DateTime
)
values
(
@message,
getdate()
)
GO