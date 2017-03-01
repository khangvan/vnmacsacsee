SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_report_psc_serial_log]
-- Define input parameters
	@pserial	char(20) = NULL -- PSC_Serial
-- Define code
AS
	--define local variable
	declare @aserial char(20) -- ACS_Serial
	set @aserial = NULL

	--Verify that non-NULLable parameter(s) have values
	if @pserial is NULL
	   begin
		raiserror ('E505.1 Illegal Parameter Value. You must specify an PSC Serial Number.',
			16,1) with nowait
		return
	   end

	--See if assembly exists
	if not exists(select Start_Station from assemblies 
		where PSC_Serial=@pserial)
	   begin
		raiserror ('E505.2 Illegal Parameter Value. Assembly %s does not exist.',
			16,1,@pserial) with nowait
		return
	   end
	select @aserial=ACS_Serial from assemblies
		where PSC_Serial=@pserial
	if @@ERROR<>0
	   begin
		raiserror('E505.3 Undefined error. Unable to obtain info from assemblies db.',17,1)
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