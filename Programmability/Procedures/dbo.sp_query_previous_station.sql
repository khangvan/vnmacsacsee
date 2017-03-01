SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_query_previous_station]
-- Define input parameters
	@aserial 		char(20) = NULL
-- Define code
AS

	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		raiserror ('E409.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			16,1) with nowait
		return
	   end
	--See if ACS Serial exists
	if not exists(select Start_Station from assemblies 
		where ACS_Serial=@aserial)
	   begin
		raiserror ('E409.2 Illegal Parameter Value. ACS Serial Number %s does not exist.',
			16,1,@aserial) with nowait
		return
	   end
	-- Create output cursor
	select Stations.Station_Name
		from asylog Inner join Stations
		on asylog.Station=Stations.Station_Count
		where asylog.ACS_Serial=@aserial
	
-- Create the Stored Procedure


GO