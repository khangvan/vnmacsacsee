SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_get_label_format]
-- Define input parameters
	@sname 		char(20) = NULL, @fname 	char(20) OUTPUT, -- Products db
	@status	char(1) OUTPUT

	

-- Define code
AS
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E205.1 Illegal Parameter Value. You must specify a Model Number.',
			16,1) with nowait
		return
	   end

	--See if Model exists
	if not exists(select Status from Products 
		where SAP_Model_Name=@sname)
	   begin
		raiserror ('E205.2 Illegal Parameter Value. Model %s does not exist.',
			16,1,@sname) with nowait
		return
	   end

	-- Get Model information
	select @fname=Format_Name,@status=Status from Products
	where SAP_Model_Name=@sname
	if @@ERROR <>0
	   begin
		raiserror('E205.3 Undefined error. Unable to retrieve Products db data.',17,1)
		return
	   end

-- Create the Stored Procedure


GO