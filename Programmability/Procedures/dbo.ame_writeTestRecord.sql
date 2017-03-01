SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_writeTestRecord]
@strvalue char(20),
@intvalue int
 AS

insert into TestTable
(
textValue,
intValue
)
values
(
@strValue,
@intValue
)
GO