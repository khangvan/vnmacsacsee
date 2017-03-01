SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_NewPurgeStation]
@sname char(20)
 AS
delete from stations where station_name = @sname
GO