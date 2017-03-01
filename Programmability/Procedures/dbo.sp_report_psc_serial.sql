SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_report_psc_serial]
-- Define input parameters
	@pserial	char(20) = NULL -- PSC_Serial
-- Define code
AS
	--Verify that non-NULLable parameter(s) have values
	if @pserial is NULL
	   begin
		raiserror ('E502.1 Illegal Parameter Value. You must specify an PSC Serial Number.',
			16,1) with nowait
		return
	   end
	--See if assembly exists
	if not exists(select Start_Station from assemblies 
		where PSC_Serial=@pserial)
	   begin
		raiserror ('E502.2 Illegal Parameter Value. Assembly %s does not exist.',
			16,1,@pserial) with nowait
		return
	   end
	-- Create output cursor
	select ACS_Serial,Products.SAP_Model_Name,Stations.Station_Name, Top_Model_Prfx, Start_Mfg, 
		End_Mfg, Sales_Order, Line_Item from assemblies Inner join Products
		on assemblies.SAP_Model_No=Products.SAP_Count Inner join Stations
		on assemblies.Start_Station=Stations.Station_Count
		where assemblies.PSC_Serial=@pserial
-- Create the Stored Procedure


GO