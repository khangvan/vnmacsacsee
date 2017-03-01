SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_NewGetAllProductLines] AS
	Select Product_Name,Top_Model_Prfx As Model_Prefix,PSC_Serial_ID,Last_PSC_Serial_Seq, 
	Stations.Station_Name As Start_Station, ProductLines.Status 
	from ProductLines inner join Stations
	on ProductLines.PSCGen_Station = Stations.Station_Count
	order by Product_Name
GO