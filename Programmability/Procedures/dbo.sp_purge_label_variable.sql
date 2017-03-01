SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_purge_label_variable]
-- Define input parameters
	@sname 		char(20) = NULL, @vname		char(20) = NULL
-- Define code
AS
	--Define local variable(s)
	declare @scount int
	set @scount = NULL
	
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E208.1 Illegal Parameter Value. You must specify a Model Number.',
			16,1) with nowait
		return
	   end
	if @vname is NULL
	   begin
		raiserror ('E208.2 Illegal Parameter Value. You must specify a Variable name.',
			16,1) with nowait
		return
	   end

	--See if Model exists
	if not exists(select Status from Products 
		where SAP_Model_Name=@sname and Status='A')
	   begin
		raiserror ('E208.3 Illegal Parameter Value. Active Model Number %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	select @scount=SAP_Count from Products
		where SAP_Model_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E208.4 Undefined error. Unable to retrieve Products db data.',17,1)
		return
	   end

	--See if Var exists
	if @vname is not NULL
	   begin
		if not exists(select SAP_Model_No from LabelVars 
			where SAP_Model_No=@scount and Var_Name=@vname)
	   	   begin
			raiserror ('E208.5 Illegal Parameter Value. Active Model Number %s does not have variable %s.',
				16,1,@sname,@vname) with nowait
			return
	   	   end
	   end			
	--Begin T-SQL Transaction
	Begin Transaction
		--Remove specific LabelVars db record(s)
		Delete from LabelVars
		where SAP_Model_No=@scount and Var_Name=@vname
		if @@ERROR <> 0
		   begin
			raiserror('E208.6 Serious Error. Failed to delete record in LabelVars db',17,1)
			Rollback Transaction
			return
		   end
	--Commit T-SQL transaction
	Commit Transaction
-- Create the Stored Procedure


GO