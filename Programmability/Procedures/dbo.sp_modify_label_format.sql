SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_modify_label_format]
-- Define input parameters
	@sname 		char(20) = NULL, @fname 	char(20) = NULL -- Catalog db
		  -- must use other stored proceedures to modify Status and Last_Started Fields
	
-- Define code
AS
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E204.1 Illegal Parameter Value. You must specify a SAP Model Number.',
			16,1) with nowait
		return
	   end
	--See if Model exists
	if not exists(select Status from Products 
		where SAP_Model_Name=@sname)
	   begin
		raiserror ('E204.2 Illegal Parameter Value. Model %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	-- Begin transaction
	Begin Transaction
		-- Update Products db record
		update Products -- Note that Status & Last_Started do not get updated here!
		SET Format_Name=@fname	
		where SAP_Model_Name=@sname
		if @@ERROR <> 0
	   	   begin
			raiserror ('E204.3 Update Error. Unable to update Products db record.',17,1)
			rollback transaction
		   end

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO