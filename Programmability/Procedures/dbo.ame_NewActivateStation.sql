SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_NewActivateStation]
@sname char(20)
 AS
update stations
set Status='A'
where station_name=@sname
GO