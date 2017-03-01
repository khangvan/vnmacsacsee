SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_checkifpartissoftwaretype]
@parttype char(5)
 AS
set nocount on

select count(*) from parttype where rtrim(result_digits) = rtrim(@parttype)
GO