SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_report_acs_serial_log]
-- Define input parameters
	@aserial	char(20) = NULL -- ACS_Serial
-- Define code
AS
	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		raiserror ('E504.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			16,1) with nowait
		return
	   end
	--See if assembly exists
	if not exists(select Start_Station from assemblies 
		where ACS_Serial=@aserial)
	   begin
		raiserror ('E504.2 Illegal Parameter Value. Assembly %s does not exist.',
			16,1,@aserial) with nowait
		return
	   end
	-- Create output cursor
	select Stations.Station_Name, Stations.Machine_Name, Actions.Description, Catalog.Part_No_Name, Catalog.Description As PartDesc,
		Scanned_Serial, Rev, Action_Date, Quantity from asylog Inner join Catalog
		on asylog.Added_Part_No=Catalog.Part_No_Count Inner join Stations
		on asylog.Station=Stations.Station_Count Inner join Actions
		on asylog.Action=Actions.Action_Count
		where asylog.ACS_Serial=@aserial
-- Create the Stored Procedure


GO