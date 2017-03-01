SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VIEW2]
AS
SELECT     dbo.Stations.Station_Name
FROM         dbo.Lines INNER JOIN
                      dbo.Stations ON dbo.Lines.Station = dbo.Stations.Station_Count

GO