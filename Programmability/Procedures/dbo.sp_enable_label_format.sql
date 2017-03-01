SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_enable_label_format]
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
		raiserror ('E215.1 Illegal Parameter Value. You must specify a SAP Model Number.',
			16,1) with nowait
		return
	   end
	--See if Model exists
	if not exists(select Status from Products 
		where SAP_Model_Name=@sname)
	   begin
		raiserror ('E215.2 Illegal Parameter Value. Model %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	--See if Model is disabled
	if not exists(select Status from Products 
		where SAP_Model_Name=@sname and Status='D')
	   begin
		raiserror ('E215.3 Illegal Parameter Value. Model %s is not disabled.',
			16,1,@sname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction -- used in this case to lock the Products db
		-- Change model status to 'A'
		UPDATE Products
		SET Status = 'A'
		WHERE SAP_Model_Name = @sname

		if @@ERROR <>0
		   Begin
			raiserror('E215.4 Serious error. Unable to update status in Products db',17,1)
			Rollback Transaction
			return
		   End

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO