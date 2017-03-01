SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_get_all_productlines]

-- Define code
AS
	Select Product_Name,Top_Model_Prfx As Model_Prefix,PSC_Serial_ID,Last_PSC_Serial_Seq, 
	Stations.Station_Name As Start_Station, ProductLines.Status 
	from ProductLines inner join Stations
	on ProductLines.PSCGen_Station = Stations.Station_Count
	order by Product_Name
	if @@ERROR <>0
	   begin
		raiserror('E309.1 Undefined error. Unable to retrieve ProductLines db data.',17,1)
		return
	   end

-- Create the Stored Procedure


GO