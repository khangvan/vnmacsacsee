SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_get_traveller]
-- Define input parameters
	@aserial 		char(20) = NULL
-- Define code
AS

	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		raiserror ('E413.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			16,1) with nowait
		return
	   end
	--See if ACS Serial exists
	if not exists(select Start_Station from assemblies 
		where ACS_Serial=@aserial)
	   begin
		raiserror ('E413.2 Illegal Parameter Value. ACS Serial Number %s does not exist.',
			16,1,@aserial) with nowait
		return
	   end
	-- Create output cursor
	select Catalog.Part_No_Name, Rev, Catalog.Description, Quantity_Required, Quantity_Filled
		from Travellers Inner join Catalog
		on Travellers.Part_No=Catalog.Part_No_Count
		where Travellers.ACS_Serial=@aserial
	
-- Create the Stored Procedure


GO