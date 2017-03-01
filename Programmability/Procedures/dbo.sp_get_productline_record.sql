SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_get_productline_record]
-- Define input parameters
	@tname 		char(5) = NULL

-- Define code
AS
	-- Init local variable
	declare @fcount int
	set @fcount = NULL
	--Verify that non-NULLable parameter(s) have values
	if @tname is NULL
	   begin
		raiserror ('E310.1 Illegal Parameter Value. You must specify a Top Model Number Prefix.',
			16,1) with nowait
		return
	   end

	--See if Top Model exists
	if not exists(select Status from ProductLines 
		where Top_Model_Prfx=@tname)
	   begin
		raiserror ('E310.2 Illegal Parameter Value. Top Model Prefix %s does not exist.',
			16,1,@tname) with nowait
		return
	   end

	-- Get Top Model information
	select  PSC_Serial_ID, Product_Name, Last_PSC_Serial_Seq, Stations.Station_Name, 
		ProductLines.Status from ProductLines Inner join Stations
		on PSCGen_Station = Stations.Station_Count
	where Top_Model_Prfx=@tname
	if @@ERROR <>0
	   begin
		raiserror('E310.3 Undefined error. Unable to retrieve ProductLines and Stations db data.',17,1)
		return
	   end


-- Create the Stored Procedure


GO