SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[PartControl]
AS
SELECT     dbo.[Catalog].Part_No_Name, dbo.Stations.Station_Name, dbo.Partlist.Menu, dbo.Partlist.Automatic, dbo.Partlist.Get_Serial, dbo.Partlist.Disp_Order, 
                      dbo.Partlist.Fill_Quantity
FROM         dbo.Partlist INNER JOIN
                      dbo.[Catalog] ON dbo.Partlist.Part_No = dbo.[Catalog].Part_No_Count INNER JOIN
                      dbo.Stations ON dbo.Partlist.Station = dbo.Stations.Station_Count

GO