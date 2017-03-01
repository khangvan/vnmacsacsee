SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_create_label_variable]
-- Define input parameters
	@sname 		char(20) = NULL, @vname	char(20) = NULL,
	@vvalue		char(30) = ''
-- Define code
AS
	--Define local variable(s)
	declare @scount int
	set @scount = NULL
	
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E207.1 Illegal Parameter Value. You must specify a Model Number.',
			16,1) with nowait
		return
	   end
	if @vname is NULL
	   begin
		raiserror ('E207.2 Illegal Parameter Value. You must specify a Variable name.',
			16,1) with nowait
		return
	   end
	--See if Model Number exists
	if not exists(select Status from Products 
		where SAP_Model_Name=@sname and Status='A')
	   begin
		raiserror ('E207.3 Illegal Parameter Value. Active Model Number %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	select @scount=SAP_Count from Products
		where SAP_Model_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E207.4 Undefined error. Unable to retrieve Products db data.',17,1)
		return
	   end

	--See if LabelVars record for this Model Number and this Variable already exists
	if exists(select SAP_Model_No from LabelVars
		where SAP_Model_No=@scount and Var_Name=@vname)
	   begin
		raiserror('E207.5 Insert error. Variable already exists for this Model Number.',16,1)
		return
	   end
	--Begin T-SQL Transaction
	Begin Transaction
		--Save new LabelVars db record
		Insert LabelVars
		Values(@scount, @vname, @vvalue)
		if @@ERROR <> 0
		   begin
			raiserror('E207.6 Serious Error. Failed to append record to LabelVars db',17,1)
			Rollback Transaction
			return
		   end
	--Commit T-SQL transaction
	Commit Transaction
-- Create the Stored Procedure


GO