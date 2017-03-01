SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



CREATE proc [dbo].[sp_change_model_number]
-- Define input parameters
	@aserial char(20) = NULL,	-- ACS_Serial
	@nmodel	char(20) = NULL		-- New Model Number
	
-- Define code
AS

	-- Define local variables
	declare @pcount int
	set @pcount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		--raiserror ('E411.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
		--	16,1) with nowait
		return 2
	   end
	if @nmodel is NULL
	   begin
		--raiserror ('E411.2 Illegal Parameter Value. You must specify a new model number.',
			--16,1) with nowait
		return 3
	   end
	--See if new model exists
	if not exists(select Status from Products 
		where SAP_Model_Name=@nmodel and Status='A')
	   begin
		--raiserror ('E411.3 Illegal Parameter Value. Model %s does not exist.',
			--16,1,@nmodel) with nowait
		return 4
	   end
	select @pcount=SAP_Count from Products
		where SAP_Model_Name=@nmodel and Status='A'
	if @@ERROR <> 0
   	   begin
		--raiserror ('E411.4 Read Error. Unable to get Products db record.',17,1)
		return 5
	   end

	--See if assembly exists
	if not exists(select Start_Station from assemblies 
		where ACS_Serial=@aserial)
	   begin
		--raiserror ('E411.5 Illegal Parameter Value. Assembly %s does not exist.',
			--16,1,@aserial) with nowait
		return 6
	   end
	-- Begin transaction
	Begin Transaction
		-- Update assemblies db record
		update assemblies
		SET SAP_Model_No=@pcount	
		where ACS_Serial=@aserial
		if @@ERROR <> 0
	   	   begin
			--raiserror ('E411.6 Update Error. Unable to update assemblies db record.',17,1)
			rollback transaction
			return 7
		   end

	--Commit T-SQL Transaction
	Commit Transaction
	return 1
-- Create the Stored Procedure
GO