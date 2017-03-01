SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_testvarchar]
@strValue varchar(1000)
 AS
set nocount on


insert into testvarchar
(
strvalue
)
values
(
@strValue
)


return 0
GO