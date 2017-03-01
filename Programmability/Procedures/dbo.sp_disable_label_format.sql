SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_disable_label_format]
-- Define input parameters
	@sname 		char(20) = NULL
	

-- Define code
AS	
	-- Define Local variables
	declare @scount	int
	set @scount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E202.1 Illegal Parameter Value. You must specify a SAP Model Number.',
			16,1) with nowait
		return
	   end
	--See if Model does not exist
	if not exists(select Status from Products 
		where SAP_Model_Name=@sname)
	   begin
		raiserror ('E202.2 Illegal Parameter Value. Model %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	-- Obtain SAP_Count value for testing
	select @scount=SAP_Count from Products 
		where SAP_Model_Name=@sname
	if @@ERROR <>0
	   Begin
		raiserror('E202.3 Serious error. Unable to obtain pcount from Products db',17,1)
		return
	   End

	-- See if Model exists in LabelVars db
	if exists(select SAP_Model_No from LabelVars
		where SAP_Model_No=@scount)
	   begin
		raiserror ('E202.4 Illegal Parameter Value. Model %s exists as part of a Label Variable Use sp_purge_label_variable first.',
			16,1,@sname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the Products db
		-- Change model status to 'D'
		UPDATE Products
		SET Status = 'D'
		WHERE SAP_Model_Name = @sname

		if @@ERROR <>0
		   Begin
			raiserror('E202.5 Serious error. Unable to update status in Products db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO