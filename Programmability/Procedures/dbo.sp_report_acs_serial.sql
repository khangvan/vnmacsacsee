SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_report_acs_serial]
-- Define input parameters
	@aserial	char(20) = NULL -- ACS_Serial
-- Define code
AS
	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		raiserror ('E501.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			16,1) with nowait
		return
	   end
	--See if assembly exists
	if not exists(select Start_Station from assemblies 
		where ACS_Serial=@aserial)
	   begin
		raiserror ('E501.2 Illegal Parameter Value. Assembly %s does not exist.',
			16,1,@aserial) with nowait
		return
	   end
	-- Create output cursor
	select Products.SAP_Model_Name,Stations.Station_Name, Top_Model_Prfx, Start_Mfg, PSC_Serial, 
		End_Mfg, Sales_Order, Line_Item from assemblies Inner join Products
		on assemblies.SAP_Model_No=Products.SAP_Count Inner join Stations
		on assemblies.Start_Station=Stations.Station_Count
		where assemblies.ACS_Serial=@aserial
-- Create the Stored Procedure


GO