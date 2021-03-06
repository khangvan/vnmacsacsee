﻿SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_purge_label_format]
-- Define input parameters
	@sname 		char(20) = NULL
	

-- Define code
AS	
	-- Define Local variables
	declare @state	char(1)
	set @state = NULL

	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E203.1 Illegal Parameter Value. You must specify a SAP Model Number.',
			16,1) with nowait
		return
	   end
	--See if Model Number does not exist
	if not exists(select SAP_Count from Products 
		where SAP_Model_Name=@sname)
	   begin
		raiserror ('E203.2 Illegal Parameter Value. Model %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	--See if Model is 'disabled'
	if not exists(select SAP_Count from Products 
		where SAP_Model_Name=@sname and Status='D')
	   begin
		raiserror ('E203.3 Illegal Parameter Value. Model %s has not been disabled. You must use sp_disable_label_format first.',
			16,1,@sname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the Products db
		-- Remove if part status is 'D'
		DELETE FROM Products
		WHERE SAP_Model_Name = @sname and Status = 'D'

		if @@ERROR <>0
		   Begin
			raiserror('E203.4 Serious error. Unable to delete record in Products db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO