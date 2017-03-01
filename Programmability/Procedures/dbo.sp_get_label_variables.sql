SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_get_label_variables]
-- Define input parameters
	@sname 		char(20) = NULL
-- Define code
AS
	--Define local variable(s)
	declare @scount int
	set @scount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E206.1 Illegal Parameter Value. You must specify a Model Number.',
			16,1) with nowait
		return
	   end
	--See if Model exists
	if not exists(select Status from Products 
		where SAP_Model_Name=@sname and Status='A')
	   begin
		raiserror ('E206.2 Illegal Parameter Value. Active Model %s does not exist.',
			16,1,@sname) with nowait
		return
	   end
	select @scount=SAP_Count from Products
		where SAP_Model_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E206.3 Undefined error. Unable to retrieve Products db data.',17,1)
		return
	   end
	-- Create output cursor
	select Var_Name, Var_Value from LabelVars where SAP_Model_No=@scount
		
-- Create the Stored Procedure


GO